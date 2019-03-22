extends TileMap
class_name Map

const OFFSET = Vector2(36, 36)
const CELL_SIZE = Vector2(54, 72)

const DEFAULT_TERRAIN := "Gg"

var width := 0
var height := 0

var locations := {}
var labels := []
var grid: Grid = null
var ZOC_tiles := []

onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap

onready var transitions := $Transitions as Transitions

onready var cell_selector := $CellSelector as Node2D
onready var unit_path_display := $UnitPathDisplay as Path2D

func _ready() -> void:
	_update_size()
	_initialize_locations()
	_initialize_grid()
	_initialize_border()
	_initialize_transitions()

	# So the initial size is also correct when first entering the editor.
	call_deferred("_update_size")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_cell: Vector2 = world_to_map(get_global_mouse_position())
		var loc: Location = get_location(mouse_cell)

		if loc:
			cell_selector.position = loc.position

func map_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world_centered(world_to_map(cell))

func find_path(start_loc: Location, end_loc: Location) -> Array:
	var loc_path := []
	var cell_path: Array = grid.find_path_by_cell(start_loc.cell, end_loc.cell)

	for cell in cell_path:
		loc_path.append(get_location(cell))

	return loc_path

func find_all_reachable_cells(unit: Unit) -> Dictionary:
	update_weight(unit)
	var paths := {}
	var cells := Hex.get_cells_in_range(unit.location.cell, unit.current_moves, width, height)
	cells.remove(0)
	cells.invert()
	for cell in cells:
		if paths.has(cell):
			continue
		var path = find_path(unit.location, get_location(cell))
		if path.empty():
			continue
		path.remove(0)
		var new_path := []
		var cost := 0
		for path_cell in path:
			var cell_cost = grid.astar.get_point_weight_scale(_flatten(path_cell.cell))
			if path_cell in ZOC_tiles:
				cell_cost = unit.current_moves - cost
			if cost + cell_cost > unit.current_moves:
				break

			cost += cell_cost
			new_path.append(path_cell)
			paths[path_cell] = new_path.duplicate(true)
			if cost == unit.current_moves:
				break
	return paths

func update_terrain() -> void:
	_initialize_locations()
	_initialize_grid()
	_initialize_transitions()

func update_weight(unit: Unit) -> void:
	for label in labels:
		remove_child(label)
	labels.clear()
	for loc in ZOC_tiles:
		grid.unblock_cell(loc.cell)
	ZOC_tiles.clear()
	for y in height:
		for x in width:
			var cell = Vector2(x, y)
			var id = _flatten(cell)
			var location : Location = locations[id]
			var cost = unit.terrain_cost(location)

			var other_unit = location.unit
			if other_unit:
				if not other_unit.side == unit.side:
					grid.block_cell(location.cell)
					ZOC_tiles.append(location)
					var current_cell := Vector2(cell.x, cell.y + 1)
					var next_cell := Vector2(cell.x, cell.y + 1)
					var neighbors = Hex.get_neighbors(location.cell)
					for neighbor in neighbors:
						if not _is_cell_in_map(neighbor):
							continue
						if unit.location.cell == neighbor:
							continue
						grid.block_cell(neighbor)
						var new_neighbors = Hex.get_neighbors(neighbor)
						for new_neighbor in new_neighbors:
							if not _is_cell_in_map(new_neighbor):
								continue
							if new_neighbor == location.cell or new_neighbor in neighbors:
								if not unit.location.cell == new_neighbor:
									continue
							if get_location(new_neighbor) in ZOC_tiles:
								if grid.astar.are_points_connected(_flatten(new_neighbor),_flatten(neighbor)):
									grid.astar.disconnect_points(_flatten(new_neighbor),_flatten(neighbor))
							else:
								grid.astar.connect_points(_flatten(new_neighbor),_flatten(neighbor),false)
						#print("zoc - " + String(current_cell))
						ZOC_tiles.append(get_location(neighbor))
			#print(cost)

			grid.astar.set_point_weight_scale(id, cost)
	#for loc in ZOC_tiles:
	#	var label : Label = Label.new()
	#	label.text = "ZOC"
	#	label.set_position(loc.position)
	#	labels.append(label)
	#	add_child(label)

func get_location(cell: Vector2) -> Location:
	if not _is_cell_in_map(cell):
		return null
	return locations[_flatten(cell)]

func set_size(cell: Vector2) -> void:
	width = int(cell.x)
	height = int(cell.y)

	_initialize_locations()
	_initialize_grid()
	_initialize_border()

func set_tile(global_pos: Vector2, id: int):
	var cell: Vector2 = world_to_map(global_pos)

	if not _is_cell_in_map(cell):
		return

	if id == -1:
		set_cellv(cell, id)
		overlay.set_cellv(cell, id)
		_update_size()

		return

	var code: String = tile_set.tile_get_name(id)
	if code.begins_with("^"):
		overlay.set_cellv(cell, id)
		if get_cellv(cell) == -1:
			var grass_id: int = tile_set.find_tile_by_name(DEFAULT_TERRAIN)
			set_cellv(cell, grass_id)
	else:
		set_cellv(cell, id)
	_update_size()

func get_map_string() -> String:
	var string := ""

	for y in height:
		for x in width:
			var id: int = _flatten(Vector2(x, y))
			if get_cell(x, y) == TileMap.INVALID_CELL:
				set_cell(x, y, tile_set.find_tile_by_name(DEFAULT_TERRAIN))
				overlay.set_cell(x, y, TileMap.INVALID_CELL)

			var code: String = tile_set.tile_get_name(get_cell(x, y))
			var overlay_code := ""

			var overlay_cell: int = overlay.get_cell(x, y)

			if overlay_cell != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay_cell)
			if x < width - 1 and y < height - 1:
				string += code + overlay_code + ","
			else:
				string += code + overlay_code
		string += "\n"

	return string

func _initialize_locations() -> void:
	for y in height:
		for x in width:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)

			var base_code := ""
			var overlay_code := ""

			var location := Location.new()

			location.map = self

			if get_cellv(cell) == TileMap.INVALID_CELL:
				set_cellv(cell, tile_set.find_tile_by_name(DEFAULT_TERRAIN))
				overlay.set_cellv(cell, TileMap.INVALID_CELL)

			if overlay.get_cellv(cell) != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay.get_cellv(cell))

			var cover_tile = tile_set.find_tile_by_name("Xv")
			cover.set_cellv(cell, cover_tile)

			base_code = tile_set.tile_get_name(get_cell(x, y))

			if overlay_code == "":
				location.terrain = Terrain.new([Registry.terrain[base_code]])
			else:
				location.terrain = Terrain.new([Registry.terrain[base_code], Registry.terrain[overlay_code]])

			location.id = id
			location.cell = Vector2(x, y)
			location.position = map_to_world_centered(cell)
			locations[id] = location

func _initialize_grid() -> void:
	grid = Grid.new(self, width, height)

func _update_size() -> void:
	if get_cell(0, 0) == -1:
		set_cell(0, 0, tile_set.find_tile_by_name(DEFAULT_TERRAIN))
	else:
		# Hack so 'get_used_rect()' returns a correct value when tiles are
		# removed. It will be fixed by GH-27080.
		var cell: int = get_cell(0, 0)
		set_cell(0, 0, 0 if cell == -1 else -1)
		set_cell(0, 0, cell)
	width = int(get_used_rect().size.x)
	height = int(get_used_rect().size.y)
	if width % 2 == 0:
		$MapBorder.rect_size =\
				map_to_world(Vector2(width, height)) + Vector2(18, 36)
	else:
		$MapBorder.rect_size =\
				map_to_world(Vector2(width, height)) + Vector2(18, 0)

func _initialize_border() -> void:
	var size := Vector2(width, height)
	print(size)
	$MapBorder.rect_size = map_to_world(size) + Vector2(18, 36)

func _initialize_transitions() -> void:
		transitions.update_transitions(self)

func _flatten(cell: Vector2) -> int:
	return int(cell.y)*int(width) + int(cell.x)

func _is_cell_in_map(cell: Vector2) -> bool:
	return cell.x >= 0 and cell.x < width and cell.y >= 0 and cell.y < height

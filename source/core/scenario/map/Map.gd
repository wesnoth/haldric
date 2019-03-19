extends TileMap
class_name Map

const OFFSET = Vector2(36, 36)
const CELL_SIZE = Vector2(54, 72)

var width := 0
var height := 0

var locations := {}
var labels := []
var grid: Grid = null

onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap
onready var cell_selector := $CellSelector as Node2D
onready var path_selector : StreamTexture = preload("res://graphics/images/terrain/path.png")

func _ready() -> void:
	_update_size()
	_initialize_locations()
	_initialize_grid()
	_initialize_border()

	# So the initial size is also correct when first entering the editor.
	call_deferred("_update_size")

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

func find_all_reachable_cells(unit: Movable) -> Dictionary:
	update_weight(unit)
	var paths := {}
	var cells := Hex.get_cells_in_range(unit.location.cell, unit.movement_points, width, height)
	cells.remove(0)
	cells.invert()
	for cell in cells:
		if paths.has(cell):
			continue
		var path = find_path(unit.location, get_location(cell))
		path.remove(0)
		var new_path := []
		var cost := 0
		for path_cell in path:
			var cell_cost = grid.astar.get_point_weight_scale(_flatten(path_cell.cell))
			if path_cell == path.back() and cell_cost > 100:
				cell_cost -= 100
			if cost + cell_cost > unit.movement_points:
				break
			cost += cell_cost
			new_path.append(path_cell)
			paths[path_cell] = new_path.duplicate(true)

	return paths

func update_weight(unit: Movable) -> void:
	for label in labels:
		remove_child(label)
	labels.clear()
	for y in height:
		for x in width:
			var cell = Vector2(x, y)
			var id = _flatten(cell)
			var location = locations[id]
			var cost = unit.terrain_cost(location)

			var other_unit = location.movable
			if other_unit:
				if not other_unit.side == unit.side:
					cost = 99
			else:
				for n_cell in Hex.get_neighbors(cell):
					if _is_out_of_bounds(n_cell):
						continue
					var n_loc = get_location(n_cell)
					if n_loc.movable and not n_loc.movable.side == unit.side:
						cost += 100
						break
			#print(cost)
			var label : Label = Label.new()
			label.text = String(cost)
			label.set_position(location.position)
			labels.append(label)
			add_child(label)
			grid.astar.set_point_weight_scale(id, cost)

func get_location(cell: Vector2) -> Location:
	if _flatten(cell) >= locations.size():
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

	if _is_out_of_bounds(cell):
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
			var grass_id: int = tile_set.find_tile_by_name("Gg")
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
				set_cell(x, y, tile_set.find_tile_by_name("Xv"))
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
				set_cellv(cell, tile_set.find_tile_by_name("Xv"))
				overlay.set_cellv(cell, TileMap.INVALID_CELL)

			if overlay.get_cellv(cell) != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay.get_cellv(cell))

			base_code = tile_set.tile_get_name(get_cell(x, y))

			if overlay_code == "":
				location.terrain = Terrain.new([Registry.terrain[base_code]])
			else:
				location.terrain = Terrain.new([Registry.terrain[base_code],
						Registry.terrain[overlay_code]])

			location.id = id
			location.cell = Vector2(x, y)
			location.position = map_to_world_centered(cell)
			locations[id] = location

func _initialize_grid() -> void:
	grid = Grid.new(self, width, height)

func _update_size() -> void:
	if get_cell(0, 0) == -1:
		set_cell(0, 0, tile_set.find_tile_by_name("Xv"))
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

func _flatten(cell: Vector2) -> int:
	return int(cell.y)*int(width) + int(cell.x)

func _is_out_of_bounds(cell: Vector2) -> bool:
	return cell.x < 0 or cell.x >= width or cell.y < 0 or cell.y >= height

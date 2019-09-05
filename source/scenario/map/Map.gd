extends TileMap
class_name Map

const OFFSET := Vector2(36, 36)

const DEFAULT_TERRAIN := "Gg"
const VOID_TERRAIN := "Xv"

var default_tile := tile_set.find_tile_by_name(DEFAULT_TERRAIN)
var void_tile := tile_set.find_tile_by_name(VOID_TERRAIN)

var rect := Rect2()

var labels := []
var locations := []
var grid: Grid = null
var ZOC_tiles := {}

onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap
onready var transitions := $Transitions as Transitions

onready var border := $MapBorder
onready var hover := $Hover

func _ready() -> void:
	_update_size()

	_initialize_locations()
	_initialize_grid()
	_initialize_transitions()

func _process(delta: float) -> void:
	var cell := world_to_map(get_global_mouse_position())

	# TODO: also hide on borders
	if not rect.has_point(cell):
		hover.hide()
	else:
		hover.show()
		hover.position = map_to_world_centered(cell)

func map_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world_centered(world_to_map(cell))

func find_path(start_loc: Location, end_loc: Location) -> Array:
	var loc_path := []
	var cell_path: PoolVector2Array = grid.find_path_by_cell(start_loc.cell, end_loc.cell)
	if cell_path.size() > 0:
		cell_path.remove(0)
		for cell in cell_path:
			loc_path.append(get_location(cell))

	return loc_path

func extend_viewable(unit: Unit) -> bool:
	var new_unit_found  = false
	#var extend_hexes := []
	#update_weight(unit, false, true)
	var cells := Hex.get_cells_around(unit.location.cell, unit.type.moves, Vector2(rect.size.x, rect.size.y))
	cells.invert()
	var cur_index = 0
	var check_radius = unit.type.moves
	var no_change = true
	var next_cutoff = check_radius * 6
	for cell in cells:
		var loc = get_location(cell)
		if not unit.side.viewable.has(loc):
			no_change = false
			var path: Array = find_path(unit.location, loc)
			var cost := 0
			for path_cell in path:
				var cell_cost = grid.get_point_weight_scale(_flatten(path_cell.cell))
				if cost + cell_cost > unit.type.moves:
					break
				cost += cell_cost
				if not unit.side.viewable.has(path_cell):
					unit.side.viewable[path_cell] = 1
					if path_cell.unit:
						if not path_cell.unit.side == unit.side:
							new_unit_found = true
							unit.side.viewable_units[path_cell.unit] = 1
					#extend_hexes.append(path_cell)
				if cost == unit.type.moves:
					break
		cur_index += 1
		if cur_index == next_cutoff:
			if no_change:
				break
			check_radius -= 1
			next_cutoff += check_radius * 6
			no_change = true

	#return extend_hexes
	return new_unit_found

#seprate wrapper function for "find_all_reachable_cells" since threads can only handle 1 argument being passed for some reason
func threadable_find_all_reachable_cells(arg_array: Array) -> Dictionary:
	if arg_array.size() == 0:
		return {}
	var unit = arg_array[0]
	var ignore_units = false if arg_array.size()  <= 1 else arg_array[1]
	var ignore_moves = false if arg_array.size()  <= 2 else arg_array[2]
	return find_all_reachable_cells(unit,ignore_units,ignore_moves)

func find_all_reachable_cells(unit: Unit, ignore_units: bool = false, ignore_moves: bool = false) -> Dictionary:
	update_weight(unit, false, ignore_units)
	var paths := {}
	paths[unit.location] = []
	var radius = (unit.type.moves if ignore_moves else unit.moves_current)
	var cells := Hex.get_cells_around(unit.location.cell, radius, Vector2(rect.size.x, rect.size.y))
	if cells.size() == 0:
		if ZOC_tiles.has(unit.location):
			for enemey_cell in ZOC_tiles[unit.location]:
				paths[enemey_cell] = [enemey_cell]
	cells.invert()
	for cell in cells:
		if paths.has(cell):
			continue
		var path: Array = find_path(unit.location, get_location(cell))
		if path.empty():
			continue
		var new_path := []
		var cost := 0
		for path_cell in path:
			var cell_cost = grid.get_point_weight_scale(_flatten(path_cell.cell))
			#if ZOC_tiles.has(path_cell) and not ignore_units:
			#	cell_cost = 1
			if cost + cell_cost > radius:
				break

			cost += cell_cost
			new_path.append(path_cell)
			paths[path_cell] = new_path.duplicate(true)
			if cost == radius:
				if ZOC_tiles.has(path_cell) and not ignore_units:
					var attack_path = new_path.duplicate(true)
					for enemey_cell in ZOC_tiles[path_cell]:
						if not paths.has(enemey_cell):
							attack_path.append(enemey_cell)
							paths[enemey_cell] = attack_path.duplicate(true)
							attack_path.pop_back()
				break
	return paths

func update_terrain() -> void:
	# TODO: no need to update everything. Restrict this to specific rects
	_update_locations()
	transitions.update_transitions()

func update_weight(unit: Unit, ignore_ZOC: bool = false, ignore_units: bool = false) -> void:
	for loc in ZOC_tiles.keys():
		grid.unblock_cell(loc.cell)
		for val in ZOC_tiles[loc]:
			grid.unblock_cell(val.cell)
	if not ignore_units:
		ZOC_tiles.clear()

	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)
			var location: Location = locations[id]
			var cost: int = unit.get_movement_cost(location)

			var other_unit = location.unit
			if not ignore_units and other_unit:
				if not other_unit.side.number == unit.side.number:
					cost = 1
					#var current_cell := Vector2(cell.x, cell.y + 1)
					#var next_cell := Vector2(cell.x, cell.y + 1)
					grid.make_cell_one_way(location.cell)
					if ignore_ZOC:
						ZOC_tiles[location]=[]
					else:
						var neighbors: Array = Hex.get_neighbors(location.cell)
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
								if (new_neighbor in neighbors and not unit.location.cell == new_neighbor):
									continue
								elif new_neighbor == location.cell:
									if not locations[_flatten(neighbor)].unit:
										grid.connect_points(_flatten(neighbor),_flatten(new_neighbor),false)
								elif get_location(new_neighbor) in ZOC_tiles.keys():
									if grid.are_points_connected(_flatten(new_neighbor),_flatten(neighbor)):
										grid.disconnect_points(_flatten(new_neighbor),_flatten(neighbor))
								else:
									grid.connect_points(_flatten(new_neighbor),_flatten(neighbor),false)
							if ZOC_tiles.has(get_location(neighbor)):
								ZOC_tiles[get_location(neighbor)].append(location)
							else:
								ZOC_tiles[get_location(neighbor)] = [location]

			grid.set_point_weight_scale(id, cost)

func set_size(size: Vector2) -> void:
	rect.size = size

	_initialize_locations()
	_initialize_grid()

func set_tile(global_pos: Vector2, id: int) -> void:
	var cell: Vector2 = world_to_map(global_pos)

	if not _is_cell_in_map(cell):
		return

	var code: String = tile_set.tile_get_name(id)

	# If an invalid tile ID was given, clear both base and overlay.
	# If an valid overlay tile was given, reset base to default if empty and set overlay.
	# If a valid base tile was given, simply set the base and leave the overlay alone.
	if id == INVALID_CELL:
		set_cellv(cell, id)
		overlay.set_cellv(cell, id)
	elif code.begins_with("^"):
		reset_if_empty(cell)
		overlay.set_cellv(cell, id)
	else:
		set_cellv(cell, id)

	_update_size()

func get_village_count() -> int:
	return overlay.get_used_cells_by_id(overlay.tile_set.find_tile_by_name("^Vh")).size()

func get_location(cell: Vector2) -> Location:
	if not _is_cell_in_map(cell):
		return null
	return locations[_flatten(cell)]

func get_pixel_size() -> Vector2:
	if int(rect.size.x) % 2 == 0:
		return map_to_world(rect.size) + Vector2(18, 36)
	else:
		return map_to_world(rect.size) + Vector2(18, 0)

func get_map_string() -> String:
	var string := ""

	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)

			reset_if_empty(cell, true)

			var code: String = tile_set.tile_get_name(get_cellv(cell))
			var overlay_code := ""

			var overlay_cell: int = overlay.get_cellv(cell)

			if overlay_cell != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay_cell)
			if x < rect.size.x - 1 and y < rect.size.y - 1:
				string += code + overlay_code + ","
			else:
				string += code + overlay_code
		string += "\n"

	return string

func _initialize_locations() -> void:
	locations.clear()
	locations.resize(rect.size.x * rect.size.y)

	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id := _flatten(cell)

			# Reset to default terrain if no terrain is specified
			reset_if_empty(cell, true)

			cover.set_cellv(cell, void_tile)

			var location := Location.new()

			location.map = self
			location.id = id
			location.cell = cell
			location.position = map_to_world_centered(cell)

			# Do this *after* setting `cell` member
			_update_terrain_record_from_map(location)

			locations[id] = location

	_initialize_border()

func _update_locations() -> void:
	for y in rect.size.y:
		for x in rect.size.x:
			_update_terrain_record_from_map(get_location(Vector2(x, y)))

func _update_terrain_record_from_map(loc: Location) -> void:
	# Find the tileset tile on both layers (base and overlay)
	var b_tile := get_cellv(loc.cell)
	var o_tile := overlay.get_cellv(loc.cell)

	# Get tile names
	var b_code := tile_set.tile_get_name(b_tile)
	var o_code := tile_set.tile_get_name(o_tile) if overlay.get_cellv(loc.cell) != INVALID_CELL else ""

	if o_code.empty():
		loc.terrain = Terrain.new([Registry.terrain[b_code]])
	else:
		loc.terrain = Terrain.new([Registry.terrain[b_code], Registry.terrain[o_code]])

func _initialize_grid() -> void:
	grid = Grid.new(self, rect)

func _initialize_border() -> void:
	border.rect_size = get_pixel_size()

func _update_size() -> void:
	reset_if_empty(Vector2(0, 0))
	rect = get_used_rect()

func _initialize_transitions() -> void:
	transitions.initialize(self)

func _flatten(cell: Vector2) -> int:
	return Utils.flatten(cell, int(rect.size.x))

func _is_cell_in_map(cell: Vector2) -> bool:
	return rect.has_point(cell)

func get_location_from_mouse() -> Location:
	return get_location(world_to_map(get_global_mouse_position()))

func display_reachable_for(reachable_locs: Dictionary) -> void:
	# "Clear" the cover map by filling in everything with the Void terrain.
	for y in rect.size.y:
		for x in rect.size.x:
			cover.set_cell(x, y, void_tile)

	# Nothing to show, hide the map and bail.
	if reachable_locs.empty():
		cover.hide()
		return;

	# Punch out visible area
	for loc in reachable_locs:
		cover.set_cellv(loc.cell, INVALID_CELL)

	cover.show()

func reset_if_empty(cell: Vector2, clear_overlay: bool = false) -> void:
	if get_cellv(cell) == INVALID_CELL:
		set_cellv(cell, default_tile)

		if clear_overlay:
			overlay.set_cellv(cell, INVALID_CELL)
func debug():
	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)
			var location: Location = locations[id]
			var label: Label = Label.new()
			label.text = str(id)
			label.set_position(location.position)
			labels.append(label)
			add_child(label)
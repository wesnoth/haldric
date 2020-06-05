extends HexMap
class_name Map

signal location_hovered(loc)

var map_data: MapData = MapData.new()

var grid : Grid = null

var locations := {}

onready var overlay := $Overlay


static func instance() -> Map:
	return load("res://source/map/Map.tscn").instance() as Map


func _ready() -> void:
	set_tile_set(TileSetBuilder.build(Data.terrains))
	_build_map()
	_build_grid()
	_build_castles()

func initialize(_map_data: MapData) -> void:
	map_data = _map_data


func get_location_from_cell(cell: Vector2) -> Location:

	if not locations.has(cell):
		return null

	return locations[cell]


func get_location_from_world(world_position: Vector2) -> Location:
	var cell = world_to_map(world_position)

	if not locations.has(cell):
		return null

	return locations[cell]


func set_tile_set(tile_set: TileSet) -> void:
	self.tile_set = tile_set
	overlay.tile_set = tile_set


func get_neighbors(loc: Location) -> Array:
	var neighbors := []
	for n_cell in Hex.get_neighbors(loc.cell):
		var n_loc := get_location_from_cell(n_cell)
		if n_loc:
			neighbors.append(n_loc)
	return neighbors


func find_path(start_loc: Location, end_loc: Location) -> Dictionary:
	var result = {
		"path": [],
		"costs": 0
	}

	var cell_path = grid.get_point_path(start_loc.id, end_loc.id)

	if not cell_path:
		return result

	cell_path.remove(0)

	var loc_path := []
	var costs := 0

	for cell in cell_path:
		var loc : Location = locations[Hex.cube2quad(cell)]
		costs += start_loc.unit.get_movement_costs(loc.terrain.type)
		loc_path.append(loc)

	result.costs = costs if costs else 99
	result.path = loc_path
	return result


func find_path_with_max_costs(start_loc: Location, end_loc: Location, max_costs: int) -> Dictionary:
	var result = {
		"path": [],
		"costs": 0
	}

	var cell_path = grid.get_point_path(start_loc.id, end_loc.id)

	if not cell_path:
		return result

	cell_path.remove(0)

	var loc_path := []
	var costs := 0

	for cell in cell_path:
		var loc : Location = locations[Hex.cube2quad(cell)]
		
		var delta_cost = start_loc.unit.get_movement_costs(loc.terrain.type)
		if delta_cost and delta_cost + costs > max_costs:
			result.costs = costs if costs else 99
			result.path = loc_path
			return result
		
		costs += start_loc.unit.get_movement_costs(loc.terrain.type)
		loc_path.append(loc)

	result.costs = costs if costs else 99
	result.path = loc_path
	return result

func find_reachable_cells(loc: Location, unit: Unit, reachable := {}, distance := 0) -> Dictionary:
	var is_first_call := loc.unit and loc.unit == unit
	var has_loc_enemy := loc.unit and loc.unit.side_number != unit.side_number
	var is_loc_zoc := false

	if has_loc_enemy and distance <= unit.moves.value:
		reachable[loc.cell] = distance

	if not is_first_call:
		distance += unit.get_movement_costs(loc.terrain.type)

	for n_loc in get_neighbors(loc):
		if n_loc.unit and n_loc.unit.side_number != unit.side_number:
			is_loc_zoc = true
			break

	is_loc_zoc = is_loc_zoc and not is_first_call

	if is_loc_zoc and distance < unit.moves.value:
		distance = unit.moves.value

	var is_loc_reachable := distance <= unit.moves.value

	if is_loc_zoc and is_loc_reachable:
		reachable[loc.cell] = unit.moves.value

		for n_loc in get_neighbors(loc):
			reachable = find_reachable_cells(n_loc, unit, reachable, distance)

		return reachable

	if not reachable.has(loc.cell) and is_loc_reachable:
		reachable[loc.cell] = distance

		for n_loc in get_neighbors(loc):
			reachable = find_reachable_cells(n_loc, unit, reachable, distance)

	elif reachable.has(loc.cell) and reachable[loc.cell] > distance and is_loc_reachable:
		reachable[loc.cell] = distance

		for n_loc in get_neighbors(loc):
			reachable = find_reachable_cells(n_loc, unit, reachable, distance)

	return reachable



func update_grid_weight(unit: Unit) -> void:
	Debug.clear_strings()

	for cell in locations.keys():
		var loc : Location = locations[cell]

		var costs := unit.get_movement_costs(loc.terrain.type)

		if loc.unit and loc.unit.side_number != unit.side_number:
			costs = 99

		for n_loc in get_neighbors(loc):
			if n_loc.unit and n_loc.unit.side_number != unit.side_number:
				if loc.unit:
					costs = 999
				else:
					costs = 99
				break

		grid.set_point_weight_scale(loc.id, costs)

	print("updated grid weight")


func get_map_data() -> MapData:
	var _map_data := MapData.new()

	for cell in locations.keys():
		var loc: Location = locations[cell]
		var terrain := loc.terrain
		var code := terrain.get_code()

		_map_data.data[cell] = code

	return _map_data


func are_locations_neighbors(loc1: Location, loc2: Location) -> bool:
	for n_cell in Hex.get_neighbors(loc1.cell):
		var n_loc := get_location_from_cell(n_cell)
		if n_loc and n_loc == loc2:
			return true
	return false


func _build_map():
	for key in map_data.data.keys():
		var cell : Vector2 = key
		var code : Array = map_data.data[key]

		var data := []
		for c in code:
			data.append(Data.terrains[c])

		_set_cell_terrain(cell, code)
		_set_cell_location(cell, data)

	var size := get_used_rect().size

	for cell in locations.keys():
		var loc : Location = locations[cell]
		loc.id = cell.y * size.x + cell.x

		var direction := 0
		for n_cell in Hex.get_neighbors(cell):
			var n_loc = get_location_from_cell(cell)

			if n_loc:
				loc.add_neighbor(n_loc, direction)

			direction += 1


func _build_grid() -> void:
	grid = Grid.new(locations.keys(), get_used_rect())


func _build_castles():
	for loc in locations.values():
		if loc.terrain.recruit_from:
			loc.castle = _find_connected_castle_locations(loc)


func _find_connected_castle_locations(keep: Location) -> Array:

	var castle := [keep]
	var visited := [keep]
	var queue := [keep]

	while queue:
		var q_loc : Location = queue.pop_front()

		for n_loc in get_neighbors(q_loc):

			if n_loc in visited:
				continue

			visited.append(n_loc)

			if not n_loc.terrain.recruit_onto:
				continue

			queue.append(n_loc)
			castle.append(n_loc)

	return castle


func _set_cell_location(cell: Vector2, terrain_data: Array) -> void:
	var loc = Location.new()
	var terrain = Terrain.new(terrain_data)

	loc.cell = cell
	loc.position = map_to_world_centered(cell)
	loc.terrain = terrain

	locations[cell] = loc;


func _set_cell_terrain(cell: Vector2, code: Array) -> void:

	set_cellv(cell, tile_set.find_tile_by_name(code[0]))

	if code.size() == 2:
		overlay.set_cellv(cell, tile_set.find_tile_by_name(code[1]))


func _on_Map_cell_hovered(cell) -> void:
	var loc : Location = get_location_from_cell(cell)

	if loc:
		emit_signal("location_hovered", loc)

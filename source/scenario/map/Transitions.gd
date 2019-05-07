extends Node2D
class_name Transitions

const tile_set = preload("res://graphics/tilesets/transitions.tres")

var map = null
var directions = [ "n", "ne", "se", "s", "sw", "nw" ]
var layers := []

# map: Map - cyclic reference
func initialize(map) -> void:
	self.map = map

	for dir in directions:
		var transition_map = TileMap.new()

		transition_map.tile_set = tile_set
		transition_map.cell_size = map.cell_size
		transition_map.cell_half_offset = map.cell_half_offset
		transition_map.cell_y_sort = map.cell_y_sort
		transition_map.use_parent_material = true

		add_child(transition_map)

	layers = get_children()

	update_transitions()

func update_transitions() -> void:
	for layer in layers:
		layer.clear()

	for cell in map.get_used_cells():
		_apply_transition_from_cell(cell)

func _apply_transition_from_cell(cell : Vector2) -> void:
	var location: Location = map.get_location(cell)
	var code: String = location.terrain.get_base_code()
	var neighbors := Hex.get_neighbors(cell)

	var layer = 0
	while layer < layers.size():
		var n_cell: Vector2 = neighbors[layer]
		var n_location: Location = map.get_location(n_cell)

		if not n_location:
			layer += 1
			continue

		if location.terrain.layer >= n_location.terrain.layer:
			layer += 1
			continue

		var transition = _get_chain_tile_data(code, cell, layer)

		if transition.directions == "":
			layer += 1
			continue

		_set_transition_tile(transition.code + "_" + transition.directions, cell, layer)
		layer += transition.chain

func _get_chain_tile_data(code: String, cell: Vector2, start_direction: int) -> Dictionary:
	var neighbors := Hex.get_neighbors(cell)

	var start_cell : Vector2 = neighbors[start_direction]
	var start_code := _get_base_terrain_code_from_cell(start_cell)

	var transition := {
		code = start_code,
		directions = "",
		chain = 0
	}

	for direction in range(start_direction, neighbors.size()):
		var n_cell : Vector2 = neighbors[direction]
		var previous := transition.duplicate(true)

		var n_code := _get_base_terrain_code_from_cell(n_cell)

		if not start_code == n_code:
			return transition

		transition.directions += _get_direction_string(start_direction, direction)
		transition.chain += 1

		if not _tile_set_has_tile(start_code + "_" + transition.directions):
			return previous

	return transition

func _get_base_terrain_code_from_cell(cell: Vector2) -> String:
	var location = map.get_location(cell)

	if location:
		return location.terrain.get_base_code()

	return ""

func _set_transition_tile(transition: String, cell: Vector2, layer: int) -> void:
	var tile_id: int = layers[layer].tile_set.find_tile_by_name(transition)
	layers[layer].set_cellv(cell, tile_id)

func _tile_set_has_tile(tile_name: String):
	return tile_set.find_tile_by_name(tile_name) != TileMap.INVALID_CELL

func _get_direction_string(start_direction: int, current_direction: int) -> String:
	if start_direction == current_direction:
		return directions[current_direction]

	return "-" + directions[current_direction]

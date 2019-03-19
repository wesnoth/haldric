extends Node2D
class_name Transitions

var directions = [ "n", "ne", "se", "s", "sw", "nw" ]

onready var layers = [ $"1", $"2", $"3", $"4", $"5", $"6", ]

func initialize(map) -> void: # : Map, cyclic reference
	print("Loading transitions on map ", Vector2(map.width, map.height))
	for y in map.height:
		for x in map.width:
			var cell = Vector2(x, y)
			var tile_id = map.get_cell(x, y)
			var code = map.tile_set.tile_get_name(tile_id)
			var neighbors = Hex.get_neighbors(cell)

			var s = ""

			var chain = 0
			for layer in 6:
				var n_cell = neighbors[layer]
				if not map._is_cell_in_map(n_cell) or layer < chain:
					continue

				var n_code = map.get_location(n_cell).terrain.code[0]
				chain = _chain(map, code, neighbors, layer)
				_set_transition_tile(n_cell, code, layer, chain)
				s += str(" ", n_code, map._flatten(n_cell), n_cell)
#
			print("Transition on ", map._flatten(cell), cell, " Code: ", code, " Neighbors: ", s)

func _chain(map, code: String, neighbors: Array, layer: int) -> int:
	for i in 6:
		var next_cell = neighbors[(layer + i + 1) % 6]

		if not map._is_cell_in_map(next_cell):
			continue

		var n_code = map.get_location(next_cell).terrain.code[0]
		var n_index = map._flatten(next_cell)

		if not map.locations.has(n_index) or not code == n_code:
			return i
	return 5

func _set_transition_tile(cell: Vector2, code: String , layer: int, chain: int) -> void:
	var transition = _get_transition_name(code, layer, chain)
	var tile_id = layers[layer].tile_set.find_tile_by_name(transition)
	layers[layer].set_cellv(cell, tile_id)
	# print("Set Tile ID: ", tile_id, " (", transition, ")", " on Layer: ", layers[layer])

func _get_transition_name(code: String , layer: int, chain: int) -> String:
	var transition = code + "_"

	for i in range(layer, 6):

		if i == layer:
			transition += directions[i]
		else:
			transition += "-" + directions[i]

		if i == chain + layer:
			break

	print("Layer: ", layer, " Chain: ", chain, " Transition: ", transition)
	return transition
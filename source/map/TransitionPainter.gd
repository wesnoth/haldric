extends Node2D
class_name TransitionPainter

const directions = [  "n", "ne", "se", "s", "sw", "nw"]

onready var layers := get_children()


func clear() -> void:
	for layer in layers:
		layer.clear()


func set_location_transition(loc: Location) -> void:
	var direction := 0
	var code = loc.terrain.get_base_code()

	for n_loc in loc.get_all_neighbors():

		if not n_loc:
			direction += 1
			return

		# print(code, " == ", loc.terrain.get_base_code(), " or ", loc.terrain.layer, " >= ", n_loc.terrain.layer)

		if n_loc.terrain.get_base_code() == code or loc.terrain.layer >= n_loc.terrain.layer:
			direction += 1
			continue


		var n_code = n_loc.terrain.get_base_code()

		if not Data.transitions.has(n_code):
			direction += 1
			continue

		var transition_data : Dictionary = Data.transitions[n_code]

		var flag := ""
		for key in transition_data.keys():

			var transition_graphic : TerrainTransitionGraphicData = transition_data[key]

			if transition_graphic.include.has(code):
				flag = key
			elif not transition_graphic.exclude.has(code):
				flag = key

		if flag:
			flag = "-" + flag

		var tile_name = n_code + flag + "-" + directions[direction]

		# print("Searching Tile ", loc.cell, ": ", tile_name)

		var tile_map = layers[direction]

		tile_map.set_cellv(loc.cell, tile_map.tile_set.find_tile_by_name(tile_name))

		direction += 1

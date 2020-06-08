extends Node2D
class_name TransitionPainter

const directions = [  "n", "ne", "se", "s", "sw", "nw"]

onready var layers := get_children()

func set_location_transition(loc: Location) -> void:
	var direction := 0
	var code = loc.terrain.get_base_code()

	for n_loc in loc.get_all_neighbors():

		if not n_loc or n_loc.terrain.get_base_code() == code:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		print("Searching Tile ", loc.cell, ": ", n_code + "-" + directions[direction])

		var tile_map = layers[direction]

		tile_map.set_cellv(loc.cell, tile_map.tile_set.find_tile_by_name(n_code + "-" + directions[direction]))

		direction += 1

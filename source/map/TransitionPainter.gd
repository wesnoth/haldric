extends Node2D
class_name TransitionPainter

const directions = [  "n", "ne", "se", "s", "sw", "nw"]

onready var layers := get_children()


func clear() -> void:
	for layer in layers:
		layer.clear()


func set_location_transition(loc: Location) -> void:
	var code = loc.terrain.get_base_code()

	var direction := 0
	for n_loc in loc.get_all_neighbors():

		if not n_loc:
			direction += 1
			return

		if n_loc.terrain.get_base_code() == code or loc.terrain.layer >= n_loc.terrain.layer:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if not Data.transitions.has(n_code):
			direction += 1
			continue

		var tile_name = _get_tile_name(code, n_code, direction)

		print("Searching Tile ", loc.cell, ": ", tile_name)

		var tile_map = layers[direction]

		tile_map.set_cellv(loc.cell, tile_map.tile_set.find_tile_by_name(tile_name))

		direction += 1


func _get_tile_name(code: String, n_code: String, direction: int) -> String:
	var n_data : Dictionary = Data.transitions[n_code]

	var flag := ""
	for key in n_data.keys():

		var n_graphic : TerrainTransitionGraphicData = n_data[key]

		if n_graphic.exclude.has(code):
			continue
		elif not n_graphic.include or n_graphic.include.has(code):
			flag = "-" + key if key else ""

	var tile_name = n_code + flag + "-" + directions[direction]
	return tile_name

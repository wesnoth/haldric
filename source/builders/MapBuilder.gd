class_name MapBuilder

const Map = preload("res://source/scenario/map/Map.tscn")

func build(res: RScenario):
	var map := Map.instance() as Map

	for data in res.map_data.values():
		var cell = data.cell
		var code = data.code
		set_base_tile(map, cell, code)

func set_base_tile(map, cell, code):
	map.update_cell_base_terrain(cell, code)

func set_transition_tile():
	pass

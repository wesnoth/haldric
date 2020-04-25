class_name MapBuilder

const Map = preload("res://source/scenario/map/Map.tscn")

func build(res: RScenario):
	var map := Map.instance() as Map

	for loc in res.map_data.values():
		pass

	pass

func set_base_tile():
	pass

func set_transition_tile():
	pass

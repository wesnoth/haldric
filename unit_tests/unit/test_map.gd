extends "res://addons/gut/test.gd"


class TestConversions:
	extends "res://addons/gut/test.gd"

	var scenarios := {}
	var file_data
	var game_scene = load("res://source/game/Game.tscn")
	var game
	var scenario_scene = load("res://unit_tests/test_scenario/test.tscn")
	var scenario
	var map

	func setup():
		for fd in Loader.load_dir("res://unit_tests/test_scenario", ["tres", "res"]):
			scenarios[fd.id] = fd
		file_data = scenarios['test']
		Global.state.scenario = file_data


	func before_each():
		## Failed attempt 1
		#game = game_scene.instance()
		#scenario = scenario_scene.instance()
		#scenario._ready()
		#scenario.map._ready()
		#gut.p(scenario.map.hover)
		#scenario.map.map_data = Global.state.scenario.data.map_data
		#scenario.initialize()

		## Failed attempt 2
		#Scene.change(Scene.Game)
		#scenario = get_tree().get_current_scene()
		#map = scenario.get_node("Map")

		pass


	#func test_map_load():
		#assert_eq(map.OFFSET, Vector2(20,20))




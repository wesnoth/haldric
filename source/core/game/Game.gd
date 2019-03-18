extends Node2D

var scenario : Scenario = null

onready var scenario_container = $ScenarioContainer

var selected_unit = null

func _unhandled_input(event : InputEvent) -> void:
	
	if event.is_action_pressed("mouse_left"):
		var mouse_cell = scenario.map.world_to_map(get_global_mouse_position())
		print(mouse_cell)
		var location = scenario.map.get_location(mouse_cell)
		if location.movable:
			selected_unit = location.movable
		elif selected_unit and not location.movable:
			selected_unit.move_to(location)
	
	elif event.is_action_pressed("mouse_right"):
		selected_unit = null

func _ready():
	_load_map()
	_load_units()

func _load_map() -> void:
	if Registry.scenarios.has(Global.scenario_name):
		scenario = load(Registry.scenarios[Global.scenario_name]).instance()
		scenario_container.add_child(scenario)
		scenario.initialize()

func _load_units() -> void:
	if scenario:
		scenario.add_unit(2, "Archer", 4, 4)
		scenario.add_unit(2, "Archer", 7, 8)

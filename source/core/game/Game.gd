extends Node2D

var scenario: Scenario = null

var selected_unit: Movable = null

onready var scenario_container := $ScenarioContainer as Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		var mouse_cell: Vector2 =\
				scenario.map.world_to_map(get_global_mouse_position())
		print(mouse_cell)
		var location: Location = scenario.map.get_location(mouse_cell)
		if location.movable:
			selected_unit = location.movable
			selected_unit.reachable = scenario.map.find_all_reachable_cells(selected_unit)
			selected_unit.highlight_moves()
		elif selected_unit and not location.movable:
			selected_unit.unhighlight_moves()
			selected_unit.move_to(location)
	
	elif event.is_action_pressed("mouse_right"):
		selected_unit.unhighlight_moves()
		selected_unit = null

func _ready() -> void:
	_load_map()
	_load_units()

func _load_map() -> void:
	if Registry.scenarios.has(Global.scenario_name):
		scenario = load(Registry.scenarios[Global.scenario_name]).instance()
		scenario_container.add_child(scenario)

func _load_units() -> void:
	if scenario:
		scenario.add_unit(1, "Archer", 4, 4)
		scenario.add_unit(2, "Archer", 7, 8)

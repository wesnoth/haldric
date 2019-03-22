extends Node2D

var scenario: Scenario = null

var selected_unit: Unit = null

onready var scenario_container := $ScenarioContainer as Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		var mouse_cell: Vector2 = scenario.map.world_to_map(get_global_mouse_position())
		print(mouse_cell)
		var location: Location = scenario.map.get_location(mouse_cell)
		if location:
			if location.unit:
				if selected_unit:
					selected_unit.unhighlight_moves()
				selected_unit = location.unit
				selected_unit.reachable = scenario.map.find_all_reachable_cells(selected_unit)
				selected_unit.highlight_moves()
			elif selected_unit and not location.unit:
				selected_unit.unhighlight_moves()
				_clear_temp_path()
				selected_unit.move_to(location)
				selected_unit = null

	elif event.is_action_pressed("mouse_right"):
		if selected_unit:
			selected_unit.unhighlight_moves()
			selected_unit = null
		_clear_temp_path()

	elif event is InputEventMouseMotion:
		var mouse_cell: Vector2 = scenario.map.world_to_map(get_global_mouse_position())
		var loc: Location = scenario.map.get_location(mouse_cell)
		if loc and selected_unit:
			if scenario.map.unit_path_display.path.empty() or not scenario.map.unit_path_display.path.back() == loc:
				_draw_temp_path(selected_unit.find_path(loc))

func _ready() -> void:
	_load_map()
	_load_units()

func _load_map() -> void:
	if Registry.scenarios.has(Global.scenario_name):
		# Look for an accompanying .tscn file
		scenario = load(Registry.scenarios[Global.scenario_name].base_path + ".tscn").instance()

		if scenario:
			scenario_container.add_child(scenario)
		else:
			print("No .tscn file found for scenario " % Global.scenario_name)

func _load_units() -> void:
	if scenario:
		scenario.add_unit(1, "Archer", 4, 4)
		scenario.add_unit(2, "Archer", 7, 8)
		scenario.add_unit(2, "Archer", 8, 8)

func _draw_temp_path(path : Array) -> void:
	scenario.map.unit_path_display.path = path

func _clear_temp_path() -> void:
	scenario.map.unit_path_display.path = [] # Uses assignment to trigger setter

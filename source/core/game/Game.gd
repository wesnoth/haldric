extends Node2D

var scenario: Scenario = null

var current_side : Side = null setget _set_side
var selected_unit: Unit = null setget _set_selected_unit

onready var HUD = $HUD as CanvasLayer
onready var scenario_container := $ScenarioContainer as Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		var mouse_cell: Vector2 = scenario.map.world_to_map(get_global_mouse_position())
		print(mouse_cell)
		var location: Location = scenario.map.get_location(mouse_cell)
		if location:
			if location.unit:
				_set_selected_unit(location.unit)
			elif selected_unit and not location.unit:
				selected_unit.move_to(location)
				scenario.unit_path_display.move_along_path(selected_unit)
				_set_selected_unit(null)

	elif event.is_action_pressed("mouse_right"):
		_set_selected_unit(null)


	elif event is InputEventMouseMotion:
		var mouse_cell: Vector2 = scenario.map.world_to_map(get_global_mouse_position())
		var loc: Location = scenario.map.get_location(mouse_cell)
		if loc and selected_unit:
			if scenario.unit_path_display.path.empty() or not scenario.unit_path_display.path.back() == loc:
				_draw_temp_path(selected_unit.find_path(loc))

func _ready() -> void:
	_load_map()
	_load_units()
	if scenario.sides.get_child_count() > 0:
		_set_side(scenario.sides.get_child(0))

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
		scenario.add_unit(2, "Fighter", 7, 8)
		scenario.add_unit(2, "Scout", 8, 8)
		scenario.add_unit(2, "Shaman", 4, 8)

func _draw_temp_path(path : Array) -> void:
	scenario.unit_path_display.path = path

func _clear_temp_path() -> void:
	scenario.unit_path_display.path = [] # Uses assignment to trigger setter

func _set_side(value):
	current_side = value
	if current_side:
		HUD.update_side_info(scenario, current_side)

func _set_selected_unit(value):
	if selected_unit:
		selected_unit.unhighlight_moves()
	selected_unit = value
	if selected_unit:
		HUD.update_unit_info(selected_unit)
		selected_unit.reachable = scenario.map.find_all_reachable_cells(selected_unit)
		selected_unit.highlight_moves()
	else:
		HUD.clear_unit_info()
		_clear_temp_path()
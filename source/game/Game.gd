extends Node2D

var time_of_day := []

var scenario: Scenario = null

var current_side: Side = null setget _set_side
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
				_set_side(scenario.sides.get_child(location.unit.side-1))
				scenario.next_time_of_day()
				_set_selected_unit(location.unit)
			elif selected_unit and not location.unit:
				selected_unit.move_to(location)
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
		scenario.add_unit(2, "Bat", 8, 8)

func _draw_temp_path(path: Array) -> void:
	if selected_unit:
		var new_path = path.duplicate(true)
		new_path.push_front(selected_unit.location)
		scenario.unit_path_display.path = new_path

func _clear_temp_path() -> void:
	scenario.unit_path_display.path = [] # Uses assignment to trigger setter

func _set_side(value: Side) -> void:
	if current_side == value:
		return
	current_side = value
	if current_side:
		var used_fog = scenario.map.fog.get_used_cells()
		for y in scenario.map.height:
			for x in scenario.map.width:
				var cell = Vector2(x,y)
				if cell in used_fog:
					continue
				scenario.map.fog.set_cellv(cell,scenario.map.cover_tile)
		HUD.update_side_info(scenario, current_side)
		for unit in current_side.units.get_children():
			unit.moves_current = unit.type.moves
			unit.viewable = scenario.map.find_all_viewable_cells(unit)
			unit.reveal_fog()

func _set_selected_unit(value: Unit) -> void:
	if selected_unit:
		selected_unit.unhighlight_moves()

	selected_unit = value

	if selected_unit:
		HUD.update_unit_info(selected_unit)
		selected_unit.set_reachable()
		selected_unit.highlight_moves()
	else:
		HUD.clear_unit_info()
		_clear_temp_path()
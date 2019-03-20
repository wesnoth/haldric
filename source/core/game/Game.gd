extends Node2D

var scenario: Scenario = null

var selected_unit: Unit = null

onready var scenario_container := $ScenarioContainer as Node2D

var path_to_cursor : Dictionary = {}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		var mouse_cell: Vector2 =\
				scenario.map.world_to_map(get_global_mouse_position())
		print(mouse_cell)
		var location: Location = scenario.map.get_location(mouse_cell)
		if location:
			if location.unit:
				selected_unit = location.unit
				selected_unit.reachable = scenario.map.find_all_reachable_cells(selected_unit)
				selected_unit.highlight_moves()
			elif selected_unit and not location.unit:
				selected_unit.unhighlight_moves()
				_clear_temp_path()
				selected_unit.move_to(location)
				selected_unit = null

	elif event.is_action_pressed("mouse_right"):
		selected_unit.unhighlight_moves()
		selected_unit = null
		_clear_temp_path()

	elif event is InputEventMouseMotion:
		var mouse_cell: Vector2 =\
				scenario.map.world_to_map(get_global_mouse_position())
		var loc : Location = scenario.map.get_location(mouse_cell)
		if loc:
			scenario.map.cell_selector.position = loc.position
			if selected_unit:
				if path_to_cursor.empty() or not path_to_cursor.keys().back() == loc:
					_clear_temp_path()
					_draw_temp_path(selected_unit.find_path(loc))


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

func _draw_temp_path(path : Array) -> void:
	for loc in path:
		var temp : Sprite = Sprite.new()
		temp.texture = scenario.map.path_selector
		temp.position = loc.position
		scenario.map.add_child(temp)
		path_to_cursor[loc] = temp

func _clear_temp_path() -> void:
	for node in path_to_cursor.values():
		scenario.map.remove_child(node)
	path_to_cursor.clear()

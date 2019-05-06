extends Node2D

var schedule := []

var scenario: Scenario = null

var current_side: Side = null setget _set_side
var selected_unit: Unit = null setget _set_selected_unit

onready var HUD := $HUD as CanvasLayer
onready var draw := $Draw as Node2D

onready var scenario_container := $ScenarioContainer as Node2D

func _unhandled_input(event: InputEvent) -> void:
	if HUD.is_pause_active():
		return

	var loc: Location = scenario.map.get_location_from_mouse()

	_update_hover(loc)

	if event.is_action_pressed("mouse_left"):
		if loc:
			# Select a unit
			if loc.unit and loc.unit.side.number == current_side.number:
				_set_selected_unit(loc.unit)

			# Move the selected unit
			elif selected_unit and not loc.unit:
				selected_unit.move_to(_get_path_for_unit(selected_unit, loc))
				_set_selected_unit(null)

	# Deselect a unit
	elif event.is_action_pressed("mouse_right"):
		_set_selected_unit(null)

	# TODO: should not be handled by mouse move
	elif event is InputEventMouseMotion:
		if loc:
			# Display selected unit's path to hovered location
			if selected_unit:
				if draw.unit_path_display.path.empty() or not draw.unit_path_display.path.back() == loc:
					_draw_temp_path(_get_path_for_unit(selected_unit, loc))
			elif loc.unit and loc.unit.visible:
				scenario.map.display_reachable_for(loc.unit.reachable)
			else:
				scenario.map.display_reachable_for({})

func _ready() -> void:
	_load_scenario()

	HUD.connect("unit_advancement_selected", self, "_on_unit_advancement_selected")

	if scenario.sides.get_child_count() > 0:
		_set_side(scenario.sides.get_child(0))

	HUD.update_time_info(scenario.schedule.current_time)

func _load_scenario() -> void:
	scenario = Loader.load_scenario(Global.scenario_name)

	# TODO: error handling
	if not scenario:
		pass

	scenario_container.add_child(scenario)
	#warning-ignore:return_value_discarded
	scenario.connect("unit_experienced", self, "_on_unit_experienced")
	#warning-ignore:return_value_discarded
	scenario.connect("unit_moved", self, "_on_unit_moved")
	#warning-ignore:return_value_discarded
	scenario.connect("unit_move_finished", self, "_on_unit_move_finished")

	draw.set_map_border_size(scenario.map.get_pixel_size())

func _update_hover(loc: Location) -> void:
	if loc:
		draw.set_hover_position(loc.position)

func _draw_temp_path(path: Array) -> void:
	if selected_unit:
		var new_path = path.duplicate(true)
		new_path.push_front(selected_unit.location)
		draw.set_path(new_path)

func _clear_temp_path() -> void:
	draw.set_path([])

func _set_side(value: Side) -> void:

	if current_side == value:
		return

	current_side = value

	if not current_side:
		return

	if current_side.get_index() % scenario.sides.get_child_count() == 0:
		scenario.turn += 1
		scenario.cycle_schedule()
		HUD.update_time_info(scenario.schedule.current_time)

	HUD.update_side_info(scenario, current_side)

	for unit in current_side.units.get_children():
		unit.moves_current = unit.type.moves
		unit.viewable = scenario.map.find_all_viewable_cells(unit)
		unit.reachable = scenario.map.find_all_reachable_cells(unit)

func _set_selected_unit(value: Unit) -> void:
	selected_unit = value

	if selected_unit:
		HUD.update_unit_info(selected_unit)
		scenario.map.display_reachable_for(selected_unit.reachable)
	else:
		# HUD.clear_unit_info()
		_clear_temp_path()

func _next_side() -> void:

	if scenario.turns >= 0 and scenario.turn > scenario.turns:
		pass # turn over

	var new_index = (current_side.get_index() + 1) % scenario.sides.get_child_count()
	_set_side(scenario.sides.get_child(new_index))

func _grab_village(unit, location) -> void:
	if location.terrain.gives_income:
		if unit.side.add_village(location):
			unit.moves_current = 0

func _get_path_for_unit(unit: Unit, new_loc: Location) -> Array:
	if unit.reachable.has(new_loc):
		return unit.reachable[new_loc]

	return scenario.map.find_path(unit.location, new_loc)

func _on_unit_experienced(unit: Unit) -> void:
	HUD.show_advancement_popup(unit)

func _on_unit_advancement_selected(unit: Unit, unit_id: String) -> void:
	unit.advance(Registry.units[unit_id].instance())

func _on_unit_moved(unit: Unit, location: Location) -> void:
	Event.emit_signal("move_to", unit, location)

func _on_unit_move_finished(unit: Unit, location: Location) -> void:
	_grab_village(unit, location)

func _on_HUD_turn_end_pressed() -> void:
	Event.emit_signal("turn_end", scenario.turn, current_side.number)
	_next_side()
	Event.emit_signal("turn_refresh", scenario.turn, current_side.number)

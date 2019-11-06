extends Node2D

var schedule := []

var scenario: Scenario = null

var current_side: Side = null setget _set_side
var current_unit: Unit = null setget _set_current_unit

onready var tween = $Tween

onready var HUD := $HUD as CanvasLayer
onready var draw := $ScenarioLayer/ViewportContainer/Viewport/Draw as Node2D

onready var viewport_container := $ScenarioLayer/ViewportContainer as ViewportContainer
onready var scenario_viewport := $ScenarioLayer/ViewportContainer/Viewport as Viewport
onready var scenario_placeholder := $ScenarioLayer/ViewportContainer/Viewport/ScenarioPlaceholder as Node
onready var camera := $ScenarioLayer/ViewportContainer/Viewport/Camera2D as Camera2D

func _unhandled_input(event: InputEvent) -> void:

	var loc: Location = scenario.map.get_location_from_mouse()
	if event.is_action_pressed("mouse_left"):
		if loc:
			# Select a unit
			if loc.unit and loc.unit.side.number == current_side.number:
				_set_current_unit(loc.unit)
				loc.unit.set_reachable()

			# Move the selected unit
			elif current_unit and (not loc.unit or loc.unit.side.number != current_side.number and current_unit.reachable.has(loc)):
				current_unit.move_to(_get_path_for_unit(current_unit, loc))
				if loc.unit and loc.unit != current_unit:
					HUD.show_attack_popup(current_unit, loc.unit)
				else:
					_set_current_unit(null)
	# Deselect a unit
	elif event.is_action_pressed("mouse_right"):
		_set_current_unit(null)

	# TODO: should not be handled by mouse move
	elif event is InputEventMouseMotion and loc:
		# Show the hovered unit in the sidebar.
		# If no unit is at the hovered location, display the currently selected unit, if any.
		if loc.unit and loc.unit.visible:
			HUD.update_unit_info(loc.unit)
		elif current_unit:
			HUD.update_unit_info(current_unit)

		# Display selected unit's path to hovered location
		if current_unit:
			if draw.unit_path_display.path.empty() or not draw.unit_path_display.path.back() == loc:
				_draw_temp_path(_get_path_for_unit(current_unit, loc))
		elif loc.unit and loc.unit.visible:
			scenario.map.display_reachable_for(loc.unit.reachable)
		else:
			scenario.map.display_reachable_for({})

	elif event is InputEventKey: #for debug purposes, will be removed later
		if event.scancode == KEY_J and event.pressed:
			if loc:
				print(loc.map.grid.get_connected_points(loc))
		if event.scancode == KEY_L and event.pressed:
			loc.map.debug()

func _ready() -> void:
	randomize()
	HUD.unit_panel.unit_viewport.world_2d = scenario_viewport.world_2d
	
	_load_scenario()
	
	$HUD/Minimap.initialize(scenario_viewport.world_2d, scenario.map.get_pixel_size(), camera)
	$HUD/Minimap.connect("map_position_change_requested", self, "_on_map_position_change_requested")

	# warning-ignore:return_value_discarded
	HUD.connect("unit_advancement_selected", self, "_on_unit_advancement_selected")
	# warning-ignore:return_value_discarded
	HUD.connect("attack_selected", self, "_on_attack_selected")
	if scenario.sides.get_child_count() > 0:
		_set_side(scenario.sides.get_child(0))
	Event.emit_signal("turn_refresh", scenario.turn, current_side.number)
	
	HUD.update_time_info(scenario.schedule.current_time)

func _on_map_position_change_requested(new_position: Vector2) -> void:
	camera.focus_on(new_position)

func _load_scenario() -> void:
	scenario = Loader.load_scenario(Global.state.scenario.id)

	# TODO: error handling
	if not scenario:
		pass

	scenario_placeholder.replace_by(scenario)
	scenario.map.map_data = Global.state.scenario.data.map_data
	scenario.initialize()

	#warning-ignore:return_value_discarded
	scenario.connect("unit_experienced", self, "_on_unit_experienced")
	#warning-ignore:return_value_discarded
	scenario.connect("unit_moved", self, "_on_unit_moved")
	#warning-ignore:return_value_discarded
	scenario.connect("unit_move_finished", self, "_on_unit_move_finished")

	draw.map_area = scenario.map.get_pixel_size()

func _draw_temp_path(path: Array) -> void:
	if current_unit:
		var new_path = path.duplicate(true)
		new_path.push_front(current_unit.location)
		draw.set_path(new_path)

func _clear_temp_path() -> void:
	draw.set_path([])

func _set_current_unit(value: Unit) -> void:
	current_unit = value

	if current_unit:
		#HUD.update_unit_info(current_unit)
		scenario.map.display_reachable_for(current_unit.reachable)
	else:
		# HUD.clear_unit_info()
		_clear_temp_path()

func _get_path_for_unit(unit: Unit, new_loc: Location) -> Array:
	if unit.reachable.has(new_loc):
		return unit.reachable[new_loc]

	return scenario.map.find_path(unit.location, new_loc)

func _set_side(value: Side) -> void:
	if current_side == value:
		return

	current_side = value
	Global.state.current_side = current_side

	if not current_side:
		return

	draw.fog.visible = current_side.fog

	if current_side.get_index() % scenario.sides.get_child_count() == 0:
		scenario.turn += 1
		scenario.cycle_schedule()
		_update_time(scenario.schedule.current_time)
		HUD.update_time_info(scenario.schedule.current_time)

	HUD.update_side_info(scenario, current_side)

func _next_side() -> void:
	if scenario.turns >= 0 and scenario.turn > scenario.turns:
		pass # turn over

	var new_index = (current_side.get_index() + 1) % scenario.sides.get_child_count()
	_set_side(scenario.sides.get_child(new_index))
	_set_current_unit(null)

func _update_time(time: Time) -> void:
	# TODO: handle better
	if time == null:
		return

	# TODO: global shader not taking individual time areas into account...
	for loc in scenario.map.locations_dict.values():
		loc.terrain.time = time

	var curr_tint: Vector3 = viewport_container.material.get_shader_param("delta")
	var next_tint: Vector3 = time.tint

	if curr_tint == null or curr_tint == next_tint:
		viewport_container.material.set_shader_param("delta", next_tint)
		return

	# warning-ignore:return_value_discarded
	tween.interpolate_property(viewport_container.material, "param/delta", null, next_tint, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func _grab_village(unit, location) -> void:
	if location.terrain.gives_income:
		if unit.side.add_village(location):
			unit.moves_current = 0
			unit.set_reachable()

func _on_unit_experienced(unit: Unit) -> void:
	HUD.show_advancement_popup(unit)

func _on_unit_advancement_selected(unit: Unit, unit_id: String) -> void:
	unit.advance(Registry.units[unit_id].instance())

func _on_attack_selected(combatChoices: Dictionary, target: Unit) -> void:
	var temp_current = current_unit
	_set_current_unit(null)
	HUD.unit_panel.clear_unit()
	temp_current.moves_current = 0
	
	combatChoices['offense'].execute_before_turn(temp_current, target)
	combatChoices['defense'].execute_before_turn(target, temp_current)
	var attacker_strikes = combatChoices['offense'].strikes
	var defender_strikes = combatChoices['defense'].strikes
	
	while attacker_strikes > 0 or defender_strikes > 0:
		if attacker_strikes > 0:
			combatChoices['offense'].execute_each_turn(temp_current, target)
			if randi() % 100 > target.get_defense():
				if target.receive_attack(combatChoices['offense']):
					target.kill(false,temp_current)
					break
			attacker_strikes -= 1
		if defender_strikes > 0:
			combatChoices['defense'].execute_each_turn(target, temp_current)
			if randi() % 100 > temp_current.get_defense():
				if temp_current.receive_attack(combatChoices['defense']):
					temp_current.kill(true,target)
					break
			defender_strikes -= 1
	
	combatChoices['offense'].execute_end_turn(temp_current, target)
	combatChoices['defense'].execute_end_turn(target, temp_current)

func _on_unit_moved(unit: Unit, location: Location) -> void:
	Event.emit_signal("move_to", unit, location)

func _on_unit_move_finished(unit: Unit, location: Location, halted: bool) -> void:
	_grab_village(unit, location)
	unit.set_reachable()
	if halted:
		_set_current_unit(unit)

func _on_HUD_turn_end_pressed() -> void:
	Event.emit_signal("turn_end", scenario.turn, current_side.number)
	_next_side()
	Event.emit_signal("turn_refresh", scenario.turn, current_side.number)

extends Node

var schedule := []

var scenario: Scenario = null

var current_side: Side = null setget _set_side

onready var HUD := $HUD as CanvasLayer
onready var draw := $ViewportContainer/Viewport/Controller/Draw as Node2D

onready var scenario_container := $ViewportContainer/Viewport/Controller/ScenarioContainer as Node2D
onready var scenario_viewport := $ViewportContainer/Viewport as Viewport

onready var controller := $ViewportContainer/Viewport/Controller as Node

func _ready() -> void:
	controller.connect("unit_selected", self, "_on_unit_selected")
	HUD.unit_panel.unit_viewport.world_2d = scenario_viewport.world_2d
	_load_scenario()

	# warning-ignore:return_value_discarded
	HUD.connect("unit_advancement_selected", self, "_on_unit_advancement_selected")

	if scenario.sides.get_child_count() > 0:
		_set_side(scenario.sides.get_child(0))

	HUD.update_time_info(scenario.schedule.current_time)

func _load_scenario() -> void:
	scenario = Loader.load_scenario(Global.scenario_name)
	controller.scenario = scenario

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

	draw.map_area = scenario.map.get_pixel_size()

func _set_side(value: Side) -> void:

	if current_side == value:
		return

	current_side = value
	controller.current_side = current_side

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

func _on_unit_selected(unit: Unit) -> void:
	HUD.update_unit_info(unit)

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

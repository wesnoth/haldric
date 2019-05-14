extends Node

signal unit_selected(unit)

var scenario : Scenario = null

var current_side : Side = null
var current_unit : Unit = null

onready var draw := $Draw as Node2D

func _input(event: InputEvent) -> void:
	
	var loc: Location = scenario.map.get_location_from_mouse()

	if event.is_action_pressed("mouse_left"):
		if loc:
			# Select a unit
			if loc.unit and loc.unit.side.number == current_side.number:
				_set_current_unit(loc.unit)

			# Move the selected unit
			elif current_unit and not loc.unit:
				current_unit.move_to(_get_path_for_unit(current_unit, loc))
				_set_current_unit(null)

	# Deselect a unit
	elif event.is_action_pressed("mouse_right"):
		_set_current_unit(null)

	# TODO: should not be handled by mouse move
	elif event is InputEventMouseMotion:
		if loc:
			# Display selected unit's path to hovered location
			if current_unit:
				if draw.unit_path_display.path.empty() or not draw.unit_path_display.path.back() == loc:
					_draw_temp_path(_get_path_for_unit(current_unit, loc))
			elif loc.unit and loc.unit.visible:
				scenario.map.display_reachable_for(loc.unit.reachable)
			else:
				scenario.map.display_reachable_for({})

func _get_path_for_unit(unit: Unit, new_loc: Location) -> Array:
	if unit.reachable.has(new_loc):
		return unit.reachable[new_loc]

	return scenario.map.find_path(unit.location, new_loc)

func _set_current_unit(value: Unit) -> void:
	current_unit = value

	if current_unit:
		emit_signal("unit_selected", current_unit)
		scenario.map.display_reachable_for(current_unit.reachable)
	else:
		# HUD.clear_unit_info()
		_clear_temp_path()

func _draw_temp_path(path: Array) -> void:
	if current_unit:
		var new_path = path.duplicate(true)
		new_path.push_front(current_unit.location)
		draw.set_path(new_path)

func _clear_temp_path() -> void:
	draw.set_path([])
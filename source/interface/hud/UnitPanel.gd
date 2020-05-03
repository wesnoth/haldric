extends Control

const AttackPlate = preload("res://source/interface/hud/components/AttackPlate.tscn")

var unit: Unit = null

onready var unit_window := $MarginContainer/VBoxContainer/Image/UnitWindow as ViewportContainer
onready var unit_viewport := $MarginContainer/VBoxContainer/Image/UnitWindow/Viewport as Viewport
onready var unit_camera := $MarginContainer/VBoxContainer/Image/UnitWindow/Viewport/Camera2D as Camera2D

onready var unit_name := $MarginContainer/VBoxContainer/Name as Label
onready var level := $MarginContainer/VBoxContainer/General/Level as Label
onready var type := $MarginContainer/VBoxContainer/General/Type as Label
onready var race := $MarginContainer/VBoxContainer/General/Race as Label
onready var hp := $MarginContainer/VBoxContainer/Health as VBoxContainer
onready var xp := $MarginContainer/VBoxContainer/Experience as VBoxContainer
onready var mp := $MarginContainer/VBoxContainer/Moves as VBoxContainer
onready var defense := $MarginContainer/VBoxContainer/Image/HBoxContainer/Backdrop/Defense
onready var alignment := $MarginContainer/VBoxContainer/Aligment

onready var resistance := $MarginContainer/VBoxContainer/ResistancePlate as Control

onready var attacks := $MarginContainer/VBoxContainer/Attacks as VBoxContainer

onready var tween := $Tween as Tween

signal recruitment_popup_requested

func _ready() -> void:
	unit_window.connect("request_scroll_to_unit", self, "_focus_camera_on_selected_unit")
	unit_camera.position = Vector2(200, 200)
	clear_unit()

# TODO: maybe find a better way to do this
func _process(delta: float) -> void:
	if unit:
		update_unit(unit)

func update_unit(target: Unit) -> void:
	_clear_attack_plates()
	# _fade_in()

	unit = target

	unit_name.text = unit.name

	unit_camera.position = unit.position

	level.text = str("L", unit.type.level)
	type.text = str(unit.type.id)
	race.text = str(unit.type.race)

	defense.text = str(unit.get_defense())  + "%"
	defense.add_color_override("font_color", _get_red_to_green_color(unit.get_defense(), 70, 30))

	unit_window.material.set_shader_param("radius", 0)

	hp.update_stat(unit.health_current, unit.type.health)
	hp.bar.tint_progress = _get_red_to_green_color(unit.health_current, unit.type.health)
	xp.update_stat(unit.experience_current, unit.type.experience)
	xp.bar.tint_progress = _get_cyan_to_white_color((100 * unit.experience_current) / unit.type.experience)
	mp.update_stat(unit.moves_current, unit.type.moves)
	mp.bar.tint_progress = _get_light_to_dark_brown((100 * unit.moves_current) / unit.type.moves)

	var tod_bonus = unit.get_time_percentage()
	if tod_bonus >= 0:
		alignment.text = "%s (+%d%%)" % [unit.type.alignment, tod_bonus]
	else:
		alignment.text = "%s (%d%%)" % [unit.type.alignment, tod_bonus]

	resistance.update_resistance(unit.type.resistance)

	for attack in unit.type.get_attacks():
		_add_attack_plate(attack)

func clear_unit() -> void:
	unit = null

	unit_window.material.set_shader_param("radius", 3)
	# _fade_out()
	unit_name.text = "-"

	level.text = "-"
	type.text = "-"
	race.text = "-"

	hp.clear()
	xp.clear()
	mp.clear()

	alignment.text = "-"

	defense.text = "-"

	_clear_attack_plates()

func _focus_camera_on_selected_unit() -> void:
	if unit:
		Global.Camera.focus_on(unit.position)

func _fade_in() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", modulate, Color("ffffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func _fade_out() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", modulate, Color("00ffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func _add_attack_plate(attack: Attack) -> void:
	var plate = AttackPlate.instance()
	attacks.add_child(plate)
	plate.update_attack_details(attack)

func _clear_attack_plates() -> void:
	for plate in attacks.get_children():
		attacks.remove_child(plate)
		plate.queue_free()

func _get_red_to_green_color(current_value: int, max_value: int, min_value:= 0) -> Color:
	# raise if min == max (division by zero)
	if max_value - min_value == 0:
		push_error("Division by zero (max_value and min_value must be different)")
	# this is a relative percentage calculation
	var ratio = float(current_value - min_value) / float(max_value - min_value)
	var r: float
	var g: float
	if ratio > 0.8: # green
		r = 0.0
		g = 1.0
	elif ratio > 0.6: # light green
		r = 0.5
		g = 1.0
	elif ratio > 0.4: # yellow
		r = 1.0
		g = 1.0
	elif ratio > 0.2: # orange
		r = 1.0
		g = 0.5
	else: # red
		r = 1.0
		g = 0.0
	return Color(r, g, 0.0)

func _get_cyan_to_white_color(value: int) -> Color:
	var mod = float(value) * 0.01
	var r = 1.0 * mod
	return Color(r, 1.0, 1.0)

func _get_light_to_dark_brown(value: int) -> Color:
	var mod = float(value) * 0.01
	return Color(0.48 * mod + 0.1, 0.4 * mod + 0.1, 0.35 * mod + 0.1)

func _on_recruitment_button_up() -> void:
	emit_signal("recruitment_popup_requested")

extends Control

const AttackPlate = preload("res://source/interface/hud/components/AttackPlate.tscn")

var unit: Unit = null

onready var unit_window := $NinePatchRect/CenterContainer/VBoxContainer/Image/UnitWindow as ViewportContainer
onready var unit_viewport := $NinePatchRect/CenterContainer/VBoxContainer/Image/UnitWindow/Viewport as Viewport
onready var unit_camera := $NinePatchRect/CenterContainer/VBoxContainer/Image/UnitWindow/Viewport/Camera2D as Camera2D

onready var unit_name := $NinePatchRect/CenterContainer/VBoxContainer/Name as Label
onready var level := $NinePatchRect/CenterContainer/VBoxContainer/General/Level as Label
onready var type := $NinePatchRect/CenterContainer/VBoxContainer/General/Type as Label
onready var race := $NinePatchRect/CenterContainer/VBoxContainer/General/Race as Label
onready var hp := $NinePatchRect/CenterContainer/VBoxContainer/Health as VBoxContainer
onready var xp := $NinePatchRect/CenterContainer/VBoxContainer/Experience as VBoxContainer
onready var mp := $NinePatchRect/CenterContainer/VBoxContainer/Moves as VBoxContainer
onready var defense := $NinePatchRect/CenterContainer/VBoxContainer/Image/Defense
onready var alignment := $NinePatchRect/CenterContainer/VBoxContainer/Aligment

onready var resistance := $NinePatchRect/CenterContainer/VBoxContainer/ResistancePlate as Control

onready var attacks := $NinePatchRect/CenterContainer/VBoxContainer/Attacks as VBoxContainer

onready var tween := $Tween as Tween


func _ready() -> void:
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
	defense.add_color_override("font_color", _get_red_to_green_color(unit.get_defense()))
	
	if not unit_window.visible:
		unit_window.visible = true

	hp.update_stat(unit.health_current, unit.type.health)
	hp.bar.tint_progress = _get_red_to_green_color((100 * unit.health_current) / unit.type.health)
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
	for plate in attacks.get_children():
		plate.clear()

func _fade_in() -> void:
	tween.interpolate_property(self, "modulate", modulate, Color("ffffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _fade_out() -> void:
	tween.interpolate_property(self, "modulate", modulate, Color("00ffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _add_attack_plate(attack: Attack) -> void:
	var plate = AttackPlate.instance()
	attacks.add_child(plate)
	plate.update_attack(attack)

func _clear_attack_plates() -> void:
	for plate in attacks.get_children():
		plate.queue_free()

func _get_red_to_green_color(defense: int) -> Color:
	var mod = float(defense) * 0.01
	var r = 1.0 - (1.0 * mod)
	var g = 1.0 * mod
	return Color(r, g, 0.0)

func _get_cyan_to_white_color(value: int) -> Color:
	var mod = float(value) * 0.01
	var r = 1.0 * mod
	return Color(r, 1.0, 1.0)

func _get_light_to_dark_brown(value: int) -> Color:
	var mod = float(value) * 0.01
	return Color(0.48 * mod + 0.1, 0.4 * mod + 0.1, 0.35 * mod + 0.1)
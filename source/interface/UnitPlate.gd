extends Node2D
class_name UnitPlate

const COLOR_GOLD := Color("FFcc00")
const COLOR_SILVER := Color("999999")
const COLOR_BRONCE := Color("663300")

onready var health := $Health as TextureProgress
onready var experience := $Experience as TextureProgress

onready var movement := $Movement as ColorRect

onready var crown := $Crown as ColorRect
onready var side := $Side as ColorRect

onready var tween := $Tween


static func instance() -> UnitPlate:
	return load("source/interface/UnitPlate.tscn").instance() as UnitPlate


func initialize(unit: Unit) -> void:
	unit.connect("advanced", self, "_on_advanced")
	unit.health.connect("value_changed", self, "_on_health_changed")
	unit.moves.connect("value_changed", self, "_on_moves_changed", [ unit ])
	unit.experience.connect("value_changed", self, "_on_experience_changed")
	unit.connect("turn_end", self, "_on_turn_end")
	unit.connect("died", self, "_on_unit_died")

	_setup_values(unit)


func _setup_values(unit: Unit) -> void:
	health.max_value = unit.health.maximum
	health.value = unit.health.value

	experience.max_value = unit.experience.maximum
	experience.value = unit.experience.value

	side.color = unit.side_color

	if unit.is_leader:
		crown.color = COLOR_GOLD
	else:
		crown.color = COLOR_BRONCE

	_on_moves_changed(unit.moves.value, unit)


func _on_advanced(unit: Unit) -> void:
	_setup_values(unit)


func _on_health_changed(value: int) -> void:
	tween.stop(health, "value")
	tween.interpolate_property(health, "value", health.value, value, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


func _on_moves_changed(value: int, unit: Unit) -> void:
	print("moves changed!")

	if unit.moves.is_full():
		movement.color = Color.green
	elif unit.moves.is_empty():
		movement.color = Color.red
	else:
		movement.color = Color.orange


func _on_experience_changed(value: int) -> void:
	tween.stop(experience, "value")
	tween.interpolate_property(experience, "value", experience.value, value, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()


func _on_turn_end() -> void:
	movement.color = Color.blue


func _on_unit_died(unit: Unit) -> void:
	tween.stop_all()
	queue_free()

extends MarginContainer
class_name CombatUnitInfo

onready var unit_type_label := $VBoxContainer/UnitType

onready var health_label := $VBoxContainer/HBoxContainer/Health
onready var moves_label := $VBoxContainer/HBoxContainer/Moves
onready var experience_label := $VBoxContainer/HBoxContainer/Experience

onready var defense_label := $VBoxContainer/Defense
onready var resistance_label := $VBoxContainer/Resistance


func update_info(loc: Location) -> void:
	clear()

	var unit := loc.unit
	var terrain := loc.terrain

	unit_type_label.text = unit.type.alias
	health_label.text = "HP: %d / %d" % [unit.health.value, unit.health.maximum]
	moves_label.text = "MP: %d / %d" % [unit.moves.value, unit.moves.maximum]
	experience_label.text = "XP: %d / %d" % [unit.experience.value, unit.experience.maximum]

	defense_label.text = "Defense: %d%%" % unit.get_defense(terrain.type)


func update_resistance(resistance: int) -> void:
	resistance_label.text = "Resistance: %d%%" % resistance


func clear() -> void:
	unit_type_label.text = ""
	health_label.text = ""
	moves_label.text = ""
	experience_label.text = ""

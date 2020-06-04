extends Control
class_name UnitUI

signal skill_selected(skill)

onready var name_label := $VBoxContainer/Name

onready var unit_type_label := $VBoxContainer/UnitType

onready var traits_label := $VBoxContainer/Traits
onready var abilities_label := $VBoxContainer/Abilities

onready var health_label := $VBoxContainer/HBoxContainer/Health
onready var moves_label := $VBoxContainer/HBoxContainer/Moves
onready var experience_label := $VBoxContainer/HBoxContainer/Experience

onready var attacks_label := $VBoxContainer/AttacksLabel
onready var skills_label := $VBoxContainer/SkillsLabel

onready var attacks := $VBoxContainer/Attacks
onready var skills := $VBoxContainer/Skills


func _ready() -> void:
	clear()


func update_info(loc: Location) -> void:

	if not loc:
		return

	var unit = loc.unit

	if not unit:
		return

	clear()

	name_label.text = unit.alias

	unit_type_label.text = unit.type.alias

	for trait in loc.unit.traits.get_children():
		traits_label.text += "(%s) " % trait.alias

	health_label.text = "HP: %d / %d" % [unit.health.value, unit.health.maximum]
	health_label.hint_tooltip = loc.unit.type.resistance.to_string()

	moves_label.text = "MP: %d / %d" % [unit.moves.value, unit.moves.maximum]
	experience_label.text = "XP: %d / %d" % [unit.experience.value, unit.experience.maximum]

	for ability in unit.get_abilities():
		abilities_label.text += ability.to_string()

	for attack in unit.get_attacks():
		var label := Label.new()
		label.text = attack.to_string()
		attacks.add_child(label)

	for skill in unit.get_skills():
		var label := Label.new()
		label.text = skill.to_string()
		skills.add_child(label)


func clear() -> void:
	name_label.text = ""

	unit_type_label.text = ""

	traits_label.text = ""
	abilities_label.text = ""

	health_label.text = ""
	moves_label.text = ""
	experience_label.text = ""

	for child in attacks.get_children():
		attacks.remove_child(child)
		child.queue_free()

	for child in skills.get_children():
		skills.remove_child(child)
		child.queue_free()


func _on_SkillUI_skill_selected(skill: Skill) -> void:
	emit_signal("skill_selected", skill)

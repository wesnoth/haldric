extends Control
class_name UnitAdvancementInfo

onready var unit_type_label := $MarginContainer/VBoxContainer/UnitType
onready var health_label := $MarginContainer/VBoxContainer/Health
onready var moves_label := $MarginContainer/VBoxContainer/Moves
onready var experience_label:= $MarginContainer/VBoxContainer/Experience

onready var attacks := $MarginContainer/VBoxContainer/Attacks
onready var skills := $MarginContainer/VBoxContainer/Skills


func update_info(unit: Unit, advancement: Advancement) -> void:
	clear()

	advancement.execute(unit)
	unit.restore()

	unit_type_label.text = unit.type.alias
	health_label.text = "HP: %d" % unit.type.health
	moves_label.text = "MP: %d" % unit.type.moves
	experience_label.text = "XP: %d" % unit.type.experience

	for attack in unit.get_attacks():
		var label := Label.new()
		attacks.add_child(label)

		label.text = attack.to_string()

	for skill in unit.get_skills():
		var label := Label.new()
		skills.add_child(label)

		label.text = skill.to_preview_string()

func clear() -> void:
	unit_type_label.text = ""
	health_label.text = ""
	moves_label.text = ""
	experience_label.text = ""

	for child in attacks.get_children():
		attacks.remove_child(child)
		child.queue_free()

	for child in skills.get_children():
		skills.remove_child(child)
		child.queue_free()

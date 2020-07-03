extends Control
class_name UnitRecallInfo

onready var unit_type_label := $MarginContainer/VBoxContainer/UnitType
onready var health_label := $MarginContainer/VBoxContainer/Health
onready var moves_label := $MarginContainer/VBoxContainer/Moves
onready var experience_label:= $MarginContainer/VBoxContainer/Experience

onready var attacks := $MarginContainer/VBoxContainer/Attacks
onready var skills := $MarginContainer/VBoxContainer/Skills
onready var traits := $MarginContainer/VBoxContainer/Traits

func update_info(unit_type: UnitType, data: Dictionary) -> void:
	clear()
	var unit = Unit.instance()
	unit.type = unit_type.duplicate()
	unit_type_label.add_child(unit)
	for trait in data["traits"]:
		var trait_obj = load("res://data/traits/%s.tscn" % trait).instance()
		unit.traits.add_child(trait_obj)
	unit.apply_traits()
	print("info-", unit.moves.maximum)
	unit_type_label.text = unit_type.alias
	
	health_label.text = "HP: %d" % unit.health.maximum
	moves_label.text = "MP: %d" % unit.moves.maximum
	experience_label.text = "XP: %d/%d" % [data["xp"], unit.experience.maximum]

	for attack in unit.get_attacks():
		var label := Label.new()
		attacks.add_child(label)

		label.text = attack.to_string()

	for skill in unit_type.skills.get_children():
		var label := Label.new()
		skills.add_child(label)

		label.text = skill.to_preview_string()
		
	for trait in data["traits"]:
		var label := Label.new()
		traits.add_child(label)

		label.text = trait
func clear() -> void:
	unit_type_label.text = ""
	for child in unit_type_label.get_children():
		unit_type_label.remove_child(child)
		child.queue_free()
	health_label.text = ""
	moves_label.text = ""
	experience_label.text = ""

	for child in attacks.get_children():
		attacks.remove_child(child)
		child.queue_free()

	for child in skills.get_children():
		skills.remove_child(child)
		child.queue_free()
		
	for child in traits.get_children():
		traits.remove_child(child)
		child.queue_free()

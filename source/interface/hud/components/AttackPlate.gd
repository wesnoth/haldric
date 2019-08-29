extends Control
class_name AttackPlate

onready var icon := $HBoxContainer/TextureRect
onready var name_label := $HBoxContainer/VBoxContainer/Name as Label
onready var details_label := $HBoxContainer/VBoxContainer/Details as Label
onready var specials_label := $HBoxContainer/VBoxContainer/Specials as Label

func update_attack(attack : Attack) -> void:
	name_label.text = "%d x %d - %s" % [attack.damage, attack.strikes, attack.name]
	details_label.text = "%s - %s" % [attack.reach, attack.type]
	icon.texture = attack.icon

func clear() -> void:
	name_label.text = ""
	details_label.text = ""
	icon.texture = null
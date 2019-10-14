extends Control
class_name AttackPlate

onready var icon := $HBoxContainer/TextureRect
onready var name_label := $HBoxContainer/VBoxContainer/Name as Label
onready var damage_label := $HBoxContainer/VBoxContainer/Damage as Label
onready var details_label := $HBoxContainer/VBoxContainer/Details as Label
onready var specials_label := $HBoxContainer/VBoxContainer/Specials as Label

func update_attack_label(attack : Attack) -> void:
	name_label.text = attack.name
	damage_label.text = "%d x %d" % [attack.damage, attack.strikes]
	details_label.text = attack.type
	icon.texture = attack.icon

func clear() -> void:
	name_label.text = ""
	details_label.text = ""
	icon.texture = null
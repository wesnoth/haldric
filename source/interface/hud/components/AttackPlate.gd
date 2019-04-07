extends Control

onready var icon := $HBoxContainer/TextureRect
onready var name_label := $HBoxContainer/VBoxContainer/Name as Label
onready var details_label := $HBoxContainer/VBoxContainer/Details as Label
onready var specials_label := $HBoxContainer/VBoxContainer/Specials as Label

func update_attack(attack : Attack) -> void:
	name_label.text = str("%d x %d - %s" % [attack.damage, attack.strikes, attack.name])
	details_label.text = str("%s - %s" % [attack.reach, attack.type])
	icon.texture = attack.icon
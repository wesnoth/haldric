extends Node2D

var yaml_parser = preload("res://addons/godot-yaml/gdyaml.gdns").new()
var test

func _ready():
	var file = File.new()
	file.open("res://units/config/orcs/Archer.yaml", File.READ)
	test = yaml_parser.parse(file.get_as_text())
	print(test.attacks)
	var popup = PopupMenu.new()
	popup.clear()
	var index = 0
	for attack in test.attacks:
		popup.add_icon_item(load(attack.icon), str(attack.name, ": ", attack.damage, " x ", attack.strikes, " (", attack.type, ")"), index)
		index += 1
	popup.connect("id_pressed", self, "on_popup_id_pressed")
	popup.show()
	add_child(popup)

func on_popup_id_pressed(ID):
	print_attack(test.attacks[ID])

func print_attack(attack):
	print(attack.name, ": ", attack.damage, " x ", attack.strikes, " (", attack.type, ")")
extends Node

var unit = {}

var parser = preload("res://addons/godot-yaml/gdyaml.gdns").new()

func _ready():
	unit["Elvish Fighter"] = {
		name = "Fighter",
		type = "Elvish Fighter",
		health = 36,
		moves = 5,
		damage = 8,
		image = "res://units/images/elves-wood/fighter.png"
	}
	unit["Orcish Archer"] = {
		name = "Archer",
		type = "Orcish Archer",
		health = 26,
		moves = 5,
		damage = 10,
		image = "res://units/images/orcs/archer.png"
	}
	
	save_file()
	load_file()

func save_file():
	var file = File.new()
	if file.open("res://yaml/unit.yaml", File.WRITE) != 0:
		print("could not open file")
		return
	var yamlstring = parser.print(unit)
	file.store_line(yamlstring)

func load_file():
	var file = File.new()
	if file.open("res://yaml/unit.yaml", File.READ) != 0:
		print("could not read file")
		return
	var dict = parser.parse(file.get_as_text())
	print(dict)
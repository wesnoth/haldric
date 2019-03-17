class_name Scenario extends Node2D

export(String) var title = ""
export(int) var turns = 99

onready var map = $Map
onready var units = $Units

func add_unit(unit : Unit, cell : Vector2) -> void:
	units.add_child(unit)
	var loc = map.get_location(cell)
	unit.move_to(loc)
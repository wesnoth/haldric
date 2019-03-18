class_name Scenario extends Node2D

export(String) var title = ""
export(int) var turns = 99

onready var map = $Map
onready var units = $Units
onready var sides = $Sides

func initialize() -> void:
	TeamColor.initializeFlagColors()

func add_unit(unit : Unit, cell : Vector2, side_number : int) -> void:
	var side : Side = sides.get_child(side_number-1)
	side.add_child(unit)
	var loc = map.get_location(cell)
	unit.move_to(loc)
	unit.sprite.set_material(side.shader)

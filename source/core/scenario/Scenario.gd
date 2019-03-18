class_name Scenario extends Node2D

export(String) var title = ""
export(int) var turns = 99

onready var map = $Map
onready var units = $Units
onready var sides = $Sides

func _ready() -> void:
	TeamColor.initializeFlagColors()

func add_unit(side_number : int, unit_id : String, x : int, y : int) -> void:

	if side_number > sides.get_child_count():
		return

	var side : Side = sides.get_child(side_number-1)
	var unit = Wesnoth.Unit.instance()

	side.add_child(unit)
	unit.initialize(Registry.units[unit_id])

	var loc = map.get_location(Vector2(x, y))
	unit.place_at(loc)

	unit.sprite.set_material(side.shader)

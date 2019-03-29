extends Node2D
class_name Scenario

onready var map := $Map as Map
onready var sides := $Sides as Node
onready var unit_path_display := $UnitPathDisplay as Path2D

func _ready() -> void:
	TeamColor.initializeFlagColors()

func add_unit(side_number: int, unit_id: String, x: int, y: int) -> void:
	if side_number > sides.get_child_count():
		return

	var side: Side = sides.get_child(side_number - 1)

	var unit := Registry.units[unit_id].instance() as Unit

	side.units.add_child(unit)
	side.calculate_upkeep()

	var loc: Location = map.get_location(Vector2(x, y))

	unit.place_at(loc)
	unit.side = side_number
	unit.sprite.set_material(side.shader)

func get_village_count():
	return map.village_count
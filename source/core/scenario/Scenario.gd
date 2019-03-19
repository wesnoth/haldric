extends Node2D
class_name Scenario

export var title := ""
export var turns := 99

onready var map := $Map as TileMap
onready var units := $Units as Node2D
onready var sides := $Sides as Node

func _ready() -> void:
	TeamColor.initializeFlagColors()

func add_unit(side_number: int, unit_id: String, x: int, y: int) -> void:
	if side_number > sides.get_child_count():
		return
	
	var side: Side = sides.get_child(side_number - 1)
	var unit := Wesnoth.Unit.instance() as Node2D
	
	side.add_child(unit)
	unit.initialize(Registry.units[unit_id])
	
	var loc: Location = map.get_location(Vector2(x, y))
	
	unit.place_at(loc)
	
	unit.sprite.set_material(side.shader)

extends Node2D
class_name Scenario

var turn := 0
var turns := -1

onready var map := $Map as Map
onready var sides := $Sides as Node
onready var time_of_day := $Times

onready var unit_path_display := $UnitPathDisplay as Path2D

func _ready() -> void:
	map.set_time_of_day(time_of_day.current_time)
	TeamColor.initialize_flag_colors()

func add_unit(side_number: int, unit_id: String, x: int, y: int) -> void:
	if side_number > sides.get_child_count():
		return

	var side: Side = sides.get_child(side_number - 1)

	var loc: Location = map.get_location(Vector2(x, y))

	var unit_type := Registry.units[unit_id].instance() as UnitType

	var unit = preload("res://source/unit/Unit.tscn").instance()

	unit.connect("move_finished", self, "_on_unit_move_finished")
	unit.initialize(unit_type)

	side.add_unit(unit)
	unit.place_at(loc)

func get_village_count() -> int:
	return map.village_count

func next_time_of_day() -> void:
	time_of_day.next()
	map.set_time_of_day(time_of_day.current_time)
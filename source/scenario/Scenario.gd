extends Node2D
class_name Scenario

signal unit_experienced(unit)
signal unit_moved(unit, location)
signal unit_move_finished(unit, location)

var turn := 0
var turns := -1

export var schedule_id := "default"

onready var map := $Map as Map
onready var sides := $Sides as Node
onready var schedule := $Schedule as Schedule

func _ready() -> void:
	_load_schedule()
	map.update_time(schedule.current_time)

func get_side(side_number: int) -> Node:
	return sides.get_child(side_number - 1)

func add_unit(side_number: int, unit_id: String, x: int, y: int) -> void:
	if side_number > sides.get_child_count():
		return

	var side: Side = sides.get_child(side_number - 1)

	var loc: Location = map.get_location(Vector2(x, y))

	var unit_type := Registry.units[unit_id].instance() as UnitType

	var unit = preload("res://source/unit/Unit.tscn").instance()
	unit.connect("experienced", self, "_on_unit_experienced")
	unit.connect("moved", self, "_on_unit_moved")
	unit.connect("move_finished", self, "_on_unit_move_finished")

	unit.type = unit_type

	side.add_unit(unit)
	unit.place_at(loc)

func get_village_count() -> int:
	return map.village_count

func cycle_schedule() -> void:
	schedule.next()
	map.update_time(schedule.current_time)

func _load_schedule() -> void:
	var time_schedule = Registry.schedules[schedule_id]
	if not time_schedule:
		time_schedule = Registry.schedules["default"]

	for time_id in time_schedule.schedule:
		if Registry.times.has(time_id):
			var res = Registry.times[time_id]
			var time = Time.new()
			schedule.add_child(time)
			time.initialize(res)

func _on_unit_experienced(unit: Unit) -> void:
	emit_signal("unit_experienced", unit)

func _on_unit_moved(unit: Unit, location: Location) -> void:
	emit_signal("unit_moved", unit, location)

func _on_unit_move_finished(unit: Unit, location: Location) -> void:
	emit_signal("unit_move_finished", unit, location)
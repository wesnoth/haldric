extends Control
class_name Scenario

const Map = preload("res://source/scenario/map/Map.tscn")

signal unit_experienced(unit)
signal unit_moved(unit, location)
signal unit_move_finished(unit, location)

var turn := 0
var turns := -1

export var schedule_id := "default"

onready var map := Map.instance() as Map
onready var sides := $Sides as Node
onready var schedule := $Schedule as Schedule

func _ready() -> void:
	add_child(map)

func _start() -> void:
	pass

func initialize() -> void:
	map.initialize()

	_load_schedule()
	update_size()
	_start()

func get_side(side_number: int) -> Side:
	return sides.get_child(side_number - 1) as Side

func add_unit_with_loaded_data(side: Side, unit_type: UnitType, target_location : Location, is_leader := false) -> void:
	var unit = Wesnoth.Unit.instance()
	unit.connect("experienced", self, "_on_unit_experienced")
	unit.connect("moved", self, "_on_unit_moved")
	unit.connect("move_finished", self, "_on_unit_move_finished")

	unit.type = unit_type

	side.add_unit(unit, is_leader)
	unit.place_at(target_location)

func add_unit(side_number: int, unit_id: String, x: int, y: int, is_leader := false) -> void:
	var unit_type: PackedScene = Registry.units[unit_id]
	if unit_type == null:
		print("Invalid unit type '%s'" % unit_id)
		return

	var side: Side = get_side(side_number)

	if side == null:
		print("Invalid side number %d" % side_number)
		return

	add_unit_with_loaded_data(side, unit_type.instance(), map.get_location(Vector2(x, y)), is_leader)


func get_village_count() -> int:
	return map.get_village_count()

func cycle_schedule() -> void:
	schedule.next()

func _load_schedule() -> void:
	var time_schedule = Registry.schedules[schedule_id]
	if not time_schedule:
		time_schedule = Registry.schedules["default"]

	for time_id in time_schedule.schedule:
		if Registry.times.has(time_id):
			var res = Registry.times[time_id]
			var time = Time.new(res)
			schedule.add_child(time)

func update_size():
	rect_size = map.border.rect_size

func _on_unit_experienced(unit: Unit) -> void:
	emit_signal("unit_experienced", unit)

func _on_unit_moved(unit: Unit, location: Location) -> void:
	emit_signal("unit_moved", unit, location)

func _on_unit_move_finished(unit: Unit, location: Location, halted: bool) -> void:
	emit_signal("unit_move_finished", unit, location, halted)

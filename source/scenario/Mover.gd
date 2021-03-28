extends Node
class_name Mover

signal finished(loc)

var movement_speed := 0.2

var unit : Unit = null
var end_loc : Location = null

var path := []

onready var tween := Tween.new()


func _ready() -> void:
	tween.name = "Tween"
	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	add_child(tween)


func start(start_loc: Location, _path: Array) -> void:
	path = _path
	unit = start_loc.unit

	if not unit:
		Console.warn("no unit at: " + str(start_loc.cell))
		_end_move(null, start_loc)
		return

	if not path:
		Console.warn("no path for: " + start_loc.unit.name)
		_end_move(unit, start_loc)
		return

	end_loc = path[path.size()-1]

	if end_loc.unit:
		Console.warn("unit at destination: " + str(end_loc.cell))
		_end_move(unit, start_loc)
		return

	start_loc.unit = null
	end_loc.unit = unit

	var delay := 0.0

	for next_loc in path:
		unit.moves.value -= unit.get_movement_costs(next_loc.terrain.type)
		tween.interpolate_property(unit, "global_position", start_loc.position, next_loc.position, movement_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
		delay += movement_speed
		start_loc = next_loc

	tween.start()
	get_tree().call_group("GameUI", "add_path", path)


func has_path_free_location(path: Array) -> bool:
	for loc in path:
		if not loc.unit:
			return true
	return false


func _end_move(unit: Unit, loc: Location) -> void:
	loc.unit = unit
	emit_signal("finished", loc)
	queue_free()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	get_tree().call_group("GameUI", "remove_path", path)
	path.remove(0)
	get_tree().call_group("GameUI", "add_path", path)


func _on_Tween_tween_all_completed() -> void:
	get_tree().call_group("GameUI", "remove_path", path)
	_end_move(unit, end_loc)

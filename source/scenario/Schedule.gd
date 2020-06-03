extends Node
class_name Schedule

signal time_changed(time)

var current_time : Time = null


func _ready() -> void:
	if get_child_count() > 0:
		current_time = get_child(0)


func next() -> void:
	if get_child_count() == 0:
		return

	if not current_time:
		current_time = get_child(0)

	var new_index = (current_time.get_index() + 1) % get_child_count()
	current_time = get_child(new_index)

	emit_signal("time_changed", current_time)


func get_schedule() -> Array:
	return get_children()

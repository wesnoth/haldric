extends Node

var current_time : DayTime = null

func _ready() -> void:
	if get_child_count() > 0:
		current_time = get_child(0)

func next() -> void:
	var new_index = (current_time.get_index() + 1) % get_child_count()
	current_time = get_child(new_index)

func get_times() -> Array:
	return get_children()

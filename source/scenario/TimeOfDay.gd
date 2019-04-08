extends CanvasModulate

var current_time : DayTime = null

func _ready() -> void:
	current_time = get_child(0)
	color = current_time.tint

func next() -> void:
	var new_index = (current_time.get_index() + 1) % get_child_count()
	current_time = get_child(new_index)
	color = current_time.tint

func get_times() -> Array:
	return get_children()


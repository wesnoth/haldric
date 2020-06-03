class_name Attribute

signal value_changed()

var maximum := 0
var value := 0 setget _set_value


func fill()-> void:
	_set_value(maximum)


func empty() -> void:
	_set_value(0)


func get_difference() -> int:
	return maximum - value


func is_full() -> bool:
	return value == maximum


func is_empty() -> bool:
	return value == 0


func _set_value(new_value: int) -> void:
	value = clamp(new_value, 0, maximum)
	emit_signal("value_changed", value)

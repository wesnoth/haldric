class_name Attribute

signal maximum_changed(maximum)
signal value_changed(value)

var maximum := 0 setget _set_maximum
var value := 0 setget _set_value


func fill()-> void:
	_set_value(maximum)


func empty() -> void:
	_set_value(0)


func get_difference() -> int:
	return maximum - value


func has_half() -> bool:
	return value >= maximum / 2


func has_third() -> bool:
	return value >= maximum / 3


func is_full() -> bool:
	return value == maximum


func is_empty() -> bool:
	return value == 0


func _set_maximum(new_maximum: int) -> void:
	maximum = new_maximum
	emit_signal("maximum_changed", maximum)


func _set_value(new_value: int) -> void:
	value = clamp(new_value, 0, maximum)
	emit_signal("value_changed", value)

extends Node
class_name Status

export var alias := ""
export(String, MULTILINE) var description := ""


func execute(_self: Location) -> void:
		_execute(_self)


func _execute(target: Location) -> void:
	pass

extends Node
class_name Trait

export var alias := ""
export(String, MULTILINE) var description := ""


func execute(unit: Unit) -> void:
	_execute(unit)


func execute_refresh(unit: Unit) -> void:
	_execute_refresh(unit)


func _execute(unit: Unit) -> void:
	pass


func _execute_refresh(unit: Unit) -> void:
	pass

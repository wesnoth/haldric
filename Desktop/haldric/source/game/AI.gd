extends Node
class_name AI

signal finished()


func initialize(side: Side) -> void:
	_initialize(side)


func execute(scenario: Scenario) -> void:
	call_deferred("_execute", scenario)
	yield(self, "finished")


func _initialize(side: Side) -> void:
	pass


func _execute(scenario: Scenario) -> void:
	yield()

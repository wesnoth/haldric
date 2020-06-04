extends Node

signal finished()

func execute(scenario: Scenario) -> void:
	Console.write("AI executed")
	emit_signal("finished")

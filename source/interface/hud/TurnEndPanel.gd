extends Control

signal turn_end_pressed

func _on_EndTurn_pressed() -> void:
	emit_signal("turn_end_pressed")

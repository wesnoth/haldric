extends Control

signal back

func _on_Back_pressed() -> void:
	emit_signal("back")
extends Control

signal back

func _on_Back_pressed():
	emit_signal("back")
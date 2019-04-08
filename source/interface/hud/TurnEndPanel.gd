extends Control

signal turn_end_pressed

func _on_Button_pressed():
	emit_signal("turn_end_pressed")

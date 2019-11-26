extends Control

onready var label = $Label as Label

func update_time(time: Time) -> void:
	label.text = time.name

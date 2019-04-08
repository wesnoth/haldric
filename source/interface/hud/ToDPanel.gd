extends Control

onready var label = $Label as Label

func update_time_of_day(daytime: DayTime) -> void:
	label.text = daytime.name
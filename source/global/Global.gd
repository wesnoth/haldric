extends Node

var selected_scenario : ScenarioData = null


func _input(event: InputEvent) -> void:
	# Toggle Fullscreen
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

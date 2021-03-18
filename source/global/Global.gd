extends Node

var selected_scenario : ScenarioData = null
var selected_sides := []
var recall_list := [
	{"id":"Bowman","level":1,"xp":7,"traits":["Quick","Dextrous"]},
	{"id":"Spearman","level":1,"xp":22,"traits":["Loyal","Strong"]}]


func _input(event: InputEvent) -> void:
	# Toggle Fullscreen
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

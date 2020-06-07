extends Node

var selected_scenario : ScenarioData = null

func _ready() -> void:
	Scene.register_scene("TitleScreen", "res://source/menu/TitleScreen.tscn")
	Scene.register_scene("ScenarioSelectionMenu", "res://source/menu/ScenarioSelectionMenu.tscn")
	Scene.register_scene("Game", "res://source/game/Game.tscn")
	Scene.register_scene("MapEditor", "res://source/editor/MapEditor.tscn")

func _input(event: InputEvent) -> void:
	# Toggle Fullscreen
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

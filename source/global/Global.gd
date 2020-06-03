extends Node

var selected_scenario : ScenarioData = null

func _ready() -> void:
	Scene.register_scene("TitleScreen", "res://source/menu/TitleScreen.tscn")
	Scene.register_scene("ScenarioSelectionMenu", "res://source/menu/ScenarioSelectionMenu.tscn")
	Scene.register_scene("Game", "res://source/game/Game.tscn")

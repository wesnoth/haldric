extends Control

onready var line_edit = $CenterContainer/VBoxContainer/LineEdit

func _on_Back_pressed():
	Scene.change(Scene.TitleScreen)

func _on_Play_pressed():
	Global.scenario_name = line_edit.text
	Scene.change(Scene.Game)

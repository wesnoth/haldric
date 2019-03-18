extends Control

onready var line_edit = $CenterContainer/VBoxContainer/LineEdit

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Play_pressed()

func _on_Back_pressed():
	Scene.change(Scene.TitleScreen)

func _on_Play_pressed():
	if not Registry.scenarios.has(line_edit.text):
		return
	Global.scenario_name = line_edit.text
	Scene.change(Scene.Game)

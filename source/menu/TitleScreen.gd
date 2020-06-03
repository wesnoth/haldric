extends Control

func _ready() -> void:
	pass # Replace with function body.


func _on_Play_pressed() -> void:
	Scene.change("ScenarioSelectionMenu")


func _on_Quit_pressed() -> void:
	get_tree().quit()

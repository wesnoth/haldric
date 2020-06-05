extends Control

func _on_Scenarios_pressed() -> void:
	Scene.change("Scenarios")

func _on_Editor_pressed() -> void:
	Scene.change("Editor", true, true)

func _on_Quit_pressed() -> void:
	get_tree().quit()

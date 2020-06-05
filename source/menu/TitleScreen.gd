extends Panel


func _on_Play_pressed() -> void:
	Scene.change("ScenarioSelectionMenu")


func _on_Editor_pressed() -> void:
	Scene.change("MapEditor")


func _on_Quit_pressed() -> void:
	get_tree().quit()

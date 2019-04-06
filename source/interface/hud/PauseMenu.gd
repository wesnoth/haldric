extends Popup

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
		else:
			popup()

func _on_Resume_pressed() -> void:
	hide()

func _on_Quit_pressed() -> void:
	Scene.change(Scene.TitleScreen)

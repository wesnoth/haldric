extends Control

onready var popup := $Popup as Popup
onready var button := $Pause as Button

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_popup()

func _popup() -> void:
	if popup.visible:
		popup.hide()
		button.show()
	else:
		popup.popup()
		button.hide()

func _on_Resume_pressed() -> void:
	popup.hide()
	button.show()

func _on_Quit_pressed() -> void:
	Scene.change(Scene.TitleScreen)

func _on_Pause_pressed() -> void:
	_popup()

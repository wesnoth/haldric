extends Control

onready var popup := $Popup as Popup
onready var button := $Pause as TouchScreenButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_popup()

func _unhandled_input(event: InputEvent) -> void:
	# This is to swap propagating events like MouseMotion when the menu is open, since
	# those aren't handled by Control. This prevents stuff like unit hovering in-game when
	# the pause menu is up. We might want to remove this if we stop using MouseMotion, or
	# if we want to go back to an is-pause-active check in _input.
	if is_active():
		get_tree().set_input_as_handled()

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

func is_active() -> bool:
	return popup.visible

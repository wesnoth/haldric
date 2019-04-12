extends MenuBar
class_name HMenuBar

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_left") and not tween.is_active():
		previous_button()
	elif event.is_action_pressed("ui_right") and not tween.is_active():
		next_button()
	elif event.is_action_pressed("ui_accept"):
		_button_selected(current_button)

func _ready() -> void:
	buttons = $HBoxContainer/Buttons.get_children()
	_register_buttons()
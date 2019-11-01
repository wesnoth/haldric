extends MenuBar
class_name VMenuBar

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_up") and not tween.is_active():
		previous_button()
	elif event.is_action_pressed("ui_down") and not tween.is_active():
		next_button()
	elif event.is_action_pressed("ui_accept"):
		_button_selected(current_button)

func _ready() -> void:
	buttons = $Buttons.get_children()
	_register_buttons()

extends ViewportContainer

signal request_scroll_to_uint

func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		emit_signal("request_scroll_to_uint")

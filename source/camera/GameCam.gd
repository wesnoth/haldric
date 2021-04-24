extends Camera2D

signal position_changed
signal zoom_changed

var initial_camera_position := Vector2()
var initial_mouse_position := Vector2()

export var speed := 4000
export var zoom_step := 0.5
export var zoom_max_in := 0.5
export var zoom_max_out := 2.0

onready var tween := $Tween


func _input(event: InputEvent) -> void:
	_handle_pitch_to_zoom(event)
	_handle_pan_gesture(event)
	_handle_mouse_scroll(event)
	_handle_middle_mouse(event)


func _process(delta: float) -> void:
	_handle_keyboard_scroll(delta)


func _handle_keyboard_scroll(delta: float) -> void:
	var speed_adjusted: float = speed * zoom.x / 2

	var new_position: Vector2 = position

	if Input.is_action_pressed("ui_up"):
		new_position.y -= speed_adjusted * delta / 2

	if Input.is_action_pressed("ui_down"):
		new_position.y += speed_adjusted * delta / 2

	if Input.is_action_pressed("ui_left"):
		new_position.x -= speed_adjusted * delta / 2

	if Input.is_action_pressed("ui_right"):
		new_position.x += speed_adjusted * delta / 2

	if(new_position != position):
		_set_position(new_position)


func _set_position(new_position : Vector2):
	emit_signal("position_changed", new_position)
	position = new_position


func _handle_pitch_to_zoom(event: InputEvent):
	if event is InputEventMagnifyGesture:
		_zoom(zoom_step * (event.factor - 1) * -10)


func _handle_pan_gesture(event: InputEvent):
	if event is InputEventPanGesture:
		if abs(event.delta.y) > 0.1:
			_zoom(zoom_step * event.delta.y)


func _handle_mouse_scroll(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			_zoom(zoom_step)
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			_zoom(zoom_step * -1)


func _zoom(step: float) -> void:
	var new_zoom := Vector2(
		clamp(zoom.x + step, zoom_max_in, zoom_max_out),
		clamp(zoom.y + step, zoom_max_in, zoom_max_out)
	)

	emit_signal("zoom_changed", new_zoom)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "zoom", null, new_zoom, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()


func _handle_middle_mouse(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()

		if not event is InputEventMouseMotion:
			initial_camera_position = position
			initial_mouse_position = mouse_pos

		# We multiply by -1 in order move the camera in the direction of the mouse.
		_set_position(initial_camera_position + (mouse_pos - initial_mouse_position) * -1 * zoom)


func focus_on(new_position: Vector2) -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_method(self, "_set_position", position, new_position, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

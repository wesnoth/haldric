extends Camera2D

var border := 4

var initial_camera_position := Vector2()
var initial_mouse_position := Vector2()

export var speed := 2000

func _input(event: InputEvent) -> void:
	_handle_mouse_scroll(event)
	_handle_middle_mouse(event)

func _ready() -> void:
	Global.Camera = self

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

	position = new_position

func _handle_mouse_scroll(event: InputEvent) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		zoom.x = clamp(zoom.x - 0.5, 0.5, 4)
		zoom.y = clamp(zoom.y - 0.5, 0.5, 4)

	if Input.is_action_just_pressed("scroll_down"):
		zoom.x = clamp(zoom.x + 0.5, 0.5, 4)
		zoom.y = clamp(zoom.y + 0.5, 0.5, 4)

func _handle_middle_mouse(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()

		if not event is InputEventMouseMotion:
			initial_camera_position = position
			initial_mouse_position = mouse_pos

		# We multiply by -1 in order move the camera in the direction of the mouse.
		position = initial_camera_position + (mouse_pos - initial_mouse_position) * -1 * zoom

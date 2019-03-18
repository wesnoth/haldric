extends Camera2D

export var speed = 2000
var border = 4

var initial_camera_position
var initial_mouse_position

func _input(event):
	var new_position = position

	if Input.is_action_just_pressed("scroll_up"):
		zoom.x = clamp(zoom.x - 0.5, 0.5, 4)
		zoom.y = clamp(zoom.y - 0.5, 0.5, 4)

	if Input.is_action_just_pressed("scroll_down"):
		zoom.x = clamp(zoom.x + 0.5, 0.5, 4)
		zoom.y = clamp(zoom.y + 0.5, 0.5, 4)

	set_position(new_position)

	if !event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			initial_camera_position = Vector2(0,0) + self.position
			initial_mouse_position = Vector2(0,0) + get_viewport().get_mouse_position()

	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		set_position(initial_camera_position + (get_viewport().get_mouse_position() - initial_mouse_position) * -1 * zoom)

func _process(delta):
	var speed = self.speed * zoom.x / 2

	var new_position = position

	if Input.is_action_pressed("ui_up"):
		new_position.y -= speed * delta / 2

	if Input.is_action_pressed("ui_down"):
		new_position.y += speed * delta / 2

	if Input.is_action_pressed("ui_left"):
		new_position.x -= speed * delta / 2

	if Input.is_action_pressed("ui_right"):
		new_position.x += speed * delta / 2

	set_position(new_position)

func set_position(new_position):
	position.x = new_position.x
	position.y = new_position.y

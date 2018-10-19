extends Camera2D

var speed = 2000
var border = 4
onready var InitialMousePosition = Vector2(0,0) + get_viewport().get_mouse_position()
onready var InitialCameraPosition = Vector2(0,0) + self.position
func _input(event):

	if Input.is_action_just_pressed("scroll_up"):
		position.y -= 100

	if Input.is_action_just_pressed("scroll_down"):
		position.y += 100
		
	if !event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			InitialCameraPosition = Vector2(0,0) + self.position
			InitialMousePosition = Vector2(0,0) + get_viewport().get_mouse_position()
		
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		var fakeposition = self.position + get_viewport().get_mouse_position() - InitialMousePosition
		self.position = InitialCameraPosition + get_viewport().get_mouse_position() - InitialMousePosition

func _process(delta):

	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta / 2

	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta / 2

	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta / 2

	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta / 2
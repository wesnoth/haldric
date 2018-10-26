extends Camera2D

var speed = 2000
var border = 4

var initial_camera_position
var initial_mouse_position

func _input(event):
	
	var new_position = position
	
	if Input.is_action_just_pressed("scroll_up"):
		new_position.y -= 100

	if Input.is_action_just_pressed("scroll_down"):
		new_position.y += 100
	
	set_position(new_position)
	
	if !event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			initial_camera_position = Vector2(0,0) + self.position
			initial_mouse_position = Vector2(0,0) + get_viewport().get_mouse_position()
		
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		set_position(initial_camera_position + (get_viewport().get_mouse_position() - initial_mouse_position) * -1)

func _process(delta):
	
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
	
	var viewport_size = get_viewport_rect().size
	var terrain_size = get_parent().terrain.map_to_world(get_parent().terrain.get_used_rect().size)
	
	if new_position.x > 17 and new_position.x < terrain_size.x - viewport_size.x:
		position.x = new_position.x
	if new_position.y > 35 and new_position.y < terrain_size.y - viewport_size.y:
		position.y = new_position.y
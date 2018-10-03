extends Camera2D

const SPEED = 1000
const BORDER = 4

var up
var down
var left
var right

var width
var height
var mouse_position

func _process(delta):
	
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	
	if up or down or left or right:
		if up:
			position.y -= SPEED * delta / 2
		if down:
			position.y += SPEED * delta / 2
		if left:
			position.x -= SPEED * delta / 2
		if right:
			position.x += SPEED * delta / 2
#	else:
#		width = get_viewport_rect().size.x / 2 - BORDER
#		height = get_viewport_rect().size.y / 2 - BORDER
#		mouse_position = get_local_mouse_position()
#		if mouse_position.x > width:
#			var factor = abs(mouse_position.x - width) / BORDER 
#			position.x += SPEED * delta * factor
#		if mouse_position.x < -width:
#			var factor = abs(mouse_position.x + width) / BORDER 
#			position.x -= SPEED * delta * factor
#		if mouse_position.y > height:
#			var factor = abs(mouse_position.y - height) / BORDER 
#			position.y += SPEED * delta * factor
#		if mouse_position.y < -height:
#			var factor = abs(mouse_position.y + height) / BORDER 
#			position.y -= SPEED * delta * factor
extends Camera2D

var speed = 2000
var border = 4

func _ready():
	smoothing_enabled = true
	smoothing_speed = 5

func _input(event):
	
	if Input.is_action_just_pressed("scroll_up"):
		position.y -= 100
	
	if Input.is_action_just_pressed("scroll_down"):
		position.y += 100

func _process(delta):
	
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta / 2
	
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta / 2
	
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta / 2
	
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta / 2
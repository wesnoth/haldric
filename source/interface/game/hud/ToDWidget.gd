extends TextureRect
class_name ToDWidget

var times : Array

var rotation_step := 360.0

var current = 0

onready var current_icon := $CurrentIcon
onready var last_icon := $LastIcon

onready var pointer := $Pointer

onready var wheel := $ToDWheel as ToDWheel

onready var bell := $Bell
onready var ambient := $Ambient

onready var tween := $Tween

var rotation := 0.0

func initialize(times: Array) -> void:
	if not times:
		return

	self.times = times

	rotation_step = 360.0 / times.size()
	pointer.rect_rotation = rotation_step / 2

	rotation = pointer.rect_rotation

	current_icon.texture = times[0].icon

	wheel.initialize(times)


func update_info(time: Time) -> void:
	_animate(time)


func _animate(time: Time) -> void:
	tween.stop_all()

	current = time.get_index()

	rotation += rotation_step

	last_icon.texture = current_icon.texture
	current_icon.texture = time.icon

	last_icon.modulate.a = 1
	current_icon.modulate.a = 0

	tween.interpolate_property(pointer, "rect_rotation", pointer.rect_rotation, rotation, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(current_icon, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(last_icon, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	bell.play()
	var time : Time = times[current]

	if time.sound:
		ambient.stream = time.sound
		ambient.play()

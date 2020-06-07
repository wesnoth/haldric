extends TextureRect
class_name ToDWidget

var icons = [
	preload("res://graphics/images/icons/ToD_icon_morning.svg"),
	preload("res://graphics/images/icons/ToD_icon_afternoon.svg"),
	preload("res://graphics/images/icons/ToD_icon_dusk.svg"),
	preload("res://graphics/images/icons/ToD_icon_firstwatch.svg"),
	preload("res://graphics/images/icons/ToD_icon_secondwatch.svg"),
	preload("res://graphics/images/icons/ToD_icon_dawn.svg"),
]

var count := 0
var rotation_step := 360.0

var current = 0

onready var current_icon := $CurrentIcon
onready var last_icon := $LastIcon

onready var pointer := $Pointer

onready var wheel := $ToDWheel as ToDWheel

onready var tween := $Tween

var rotation := 0.0

func initialize(times: Array) -> void:
	if not times:
		return

	count = times.size()

	rotation_step = 360.0 / count
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

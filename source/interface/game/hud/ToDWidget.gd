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

var count := 6
var rotation_step = 360.0 / count

var current = 0

onready var current_icon := $CurrentIcon
onready var last_icon := $LastIcon

onready var pointer := $Pointer

onready var wheel := $ToDWheel

onready var tween := $Tween


func _ready() -> void:
	current_icon.texture = icons[current]
	pointer.rect_rotation = rotation_step / 2

	wheel.initialize(
		[
			{ "color": Color.yellow },
			{ "color": Color.white },
			{ "color": Color.white },
			{ "color": Color.orange },
			{ "color": Color.blue },
			{ "color": Color.blue },
		]
	)

func update_info() -> void:
	pass
	pass


func _on_Timer_timeout() -> void:
	current = (current + 1) % count
	var new_rotation = int(pointer.rect_rotation + rotation_step)

	last_icon.texture = current_icon.texture
	current_icon.texture = icons[current]

	last_icon.modulate.a = 1
	current_icon.modulate.a = 0

	tween.interpolate_property(pointer, "rect_rotation", pointer.rect_rotation, new_rotation, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(current_icon, "modulate:a", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(last_icon, "modulate:a", 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

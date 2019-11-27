extends Control
class_name ToDWheel

var times := []

var angle_step := 360.0

onready var center = rect_size / 2

func initialize(times: Array) -> void:
	self.times = times
	if times:
		angle_step = 360.0 / times.size()

func _process(delta: float) -> void:
	rect_rotation += 50 * delta

func _draw() -> void:
	for i in times.size():
		draw_arc(center, center.x / 2, deg2rad(angle_step * i), deg2rad(angle_step * (i + 1)), 360, times[i].color, center.x, true)

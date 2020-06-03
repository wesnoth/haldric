extends Node2D
class_name DebugDraw

const FONT = preload("res://graphics/fonts/droid-sans/DroidSans16.tres")

var circles := []
var strings := []

func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	if circles:
		for c in circles:
			draw_circle(c.position, c.radius, c.color)

	if strings:
		for s in strings:
			draw_string(FONT, s.position, s.text, s.color)

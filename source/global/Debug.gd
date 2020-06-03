extends CanvasLayer

onready var draw := $DebugDraw


func draw_circle(position: Vector2, radius: int, color := Color("FFFFFF")) -> void:
	draw.circles.append({
		"position": position,
		"radius": radius,
		"color": color
	})


func draw_string(position: Vector2, text: String, color := Color("FFFFFF")) -> void:
	draw.strings.append({
		"position": position,
		"text": text,
		"color": color
	})


func clear_circles() -> void:
	draw.circles = []


func clear_strings() -> void:
	draw.strings = []

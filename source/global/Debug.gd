extends CanvasLayer

onready var draw := $DebugDraw


func draw_line(from: Vector2, to: Vector2, color := Color.white, width := 2) -> void:
	draw.lines.append({
		"from": from,
		"to": to,
		"color": color,
		"width": width,
	})


func draw_circle(position: Vector2, radius: int, color := Color.white) -> void:
	draw.circles.append({
		"position": position,
		"radius": radius,
		"color": color
	})


func draw_string(position: Vector2, text: String, color := Color.white) -> void:
	draw.strings.append({
		"position": position,
		"text": text,
		"color": color
	})


func clear_circles() -> void:
	draw.circles = []


func clear_strings() -> void:
	draw.strings = []

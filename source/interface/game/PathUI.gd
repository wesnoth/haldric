extends Node2D
class_name PathUI

var paths := []


func _process(delta: float) -> void:
	update()


func show_path(path: Array) -> void:
	paths.append(path)


func erase(path: Array) -> void:
	paths.erase(path)


func clear_all() -> void:
	paths = []

func _draw() -> void:

	for path in paths:
		for loc in path:
			draw_circle(loc.position, 16, Color("66FFFFFF"))

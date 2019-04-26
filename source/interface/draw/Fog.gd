extends Node2D

var texture

func _draw() -> void:
	if texture:
		draw_texture(texture, Vector2(0, 0))
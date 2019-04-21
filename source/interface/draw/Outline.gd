extends Node2D

var texture

func _ready() -> void:
	material = null # as long as we don't use it, don't make efforts to calculate shaders

func _draw() -> void:
	if texture:
		draw_texture(texture, Vector2(0, 0))
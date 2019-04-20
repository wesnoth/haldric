extends Node2D

var texture

func _draw() -> void:
	if Global.Camera:
		material.set_shader_param("offset", Global.Camera.global_position / get_viewport_rect().size)

	if texture:
		draw_texture(texture, Vector2(0, 0))
extends Node2D

var texture

func _process(delta: float) -> void:
	if Global.Camera:
		var offset = Global.Camera.global_position / get_viewport_rect().size
		material.set_shader_param("offset", offset / Global.Camera.zoom)

func _draw() -> void:
	if texture:
		draw_texture(texture, Vector2(0, 0))
extends TileMap

func _process(delta):
	if Global.Camera:
		material.set_shader_param("offset", Global.Camera.global_position / get_viewport_rect().size)
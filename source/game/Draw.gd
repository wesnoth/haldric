extends Node2D

onready var viewport = $Viewport
onready var fog_texture = $Viewport/FogTexture
onready var fog = $Fog

func _process(delta: float) -> void:
	var size = get_parent().scenario.map.map_border.rect_size
	var side = get_parent().current_side.number

	viewport.size = size
	fog_texture.side = side
	fog.texture = viewport.get_texture()


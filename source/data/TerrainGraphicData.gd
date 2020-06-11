extends Resource
class_name TerrainGraphicData

var offset := Vector2()

var texture : Texture = null

var variations := []

func get_textures() -> Array:
	return [ texture ] + variations

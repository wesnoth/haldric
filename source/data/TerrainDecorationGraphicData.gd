class_name TerrainDecorationGraphicData

var code := ""
var image_stem := ""

var offset := Vector2()

var texture : Texture = null
var variations := []

func get_textures() -> Array:
	return [ texture ] + variations


func allow_drawing(code: String) -> bool:
	return self.code == code

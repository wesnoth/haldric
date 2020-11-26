class_name TerrainDecorationGraphicData

var code := ""
var image_stem := ""

var offset := Vector2()

var textures := []


func allow_drawing(code: String) -> bool:
	return self.code == code

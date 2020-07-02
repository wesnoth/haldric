class_name TerrainTransitionGraphicData

var code := ""
var image_stem := ""

var exclude := []
var include := []

var textures := {}


func allow_drawing(code: String) -> bool:
	if exclude.has(code):
		return false

	if not include or include.has(code):
		return true

	return false

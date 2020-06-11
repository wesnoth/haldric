class_name CastleWallTowerGraphicData

var code := ""

var include := []
var exclude := []

var texture : Texture = null
var offset := Vector2()


func allow_drawing(code: String) -> bool:
	if exclude.has(code):
		return false

	if not include or include.has(code):
		return true

	return false

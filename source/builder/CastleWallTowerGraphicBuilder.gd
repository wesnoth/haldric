class_name CastleWallTowerGraphicBuilder

var graphic = CastleWallTowerGraphicData.new()


func new_graphic() -> CastleWallTowerGraphicBuilder:
	graphic = CastleWallTowerGraphicData.new()
	return self


func with_code(code: String) -> CastleWallTowerGraphicBuilder:
	graphic.code = code
	return self


func with_texture(texture: Texture) -> CastleWallTowerGraphicBuilder:
	graphic.texture = texture
	return self


func with_offset(offset: Vector2) -> CastleWallTowerGraphicBuilder:
	graphic.offset = offset
	return self


func build() -> CastleWallTowerGraphicBuilder:
	return graphic

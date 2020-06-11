class_name CastleWallSegmentGraphicBuilder

var graphic = CastleWallSegmentGraphicData.new()


func new_graphic() -> CastleWallSegmentGraphicBuilder:
	graphic = CastleWallSegmentGraphicData.new()
	return self


func with_code(code: String) -> CastleWallSegmentGraphicBuilder:
	graphic.code = code
	return self

	
func with_texture(texture: Texture) -> CastleWallSegmentGraphicBuilder:
	graphic.texture = texture
	return self


func with_offset(offset: Vector2) -> CastleWallSegmentGraphicBuilder:
	graphic.offset = offset
	return self


func build() -> CastleWallSegmentGraphicData:
	return graphic

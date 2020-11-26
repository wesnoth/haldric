class_name TerrainDecorationGraphicBuilder

var graphic := TerrainDecorationGraphicData.new()


func new_graphic() -> TerrainDecorationGraphicBuilder:
	graphic = TerrainDecorationGraphicData.new()
	return self


func with_code(code: String) -> TerrainDecorationGraphicBuilder:
	graphic.code = code
	return self


func with_offset(offset: Vector2) -> TerrainDecorationGraphicBuilder:
	graphic.offset = offset
	return self


func with_textures(textures: Array) -> TerrainDecorationGraphicBuilder:
	graphic.textures = textures
	return self


func with_image_stem(image_stem: String) -> TerrainDecorationGraphicBuilder:
	graphic.image_stem = image_stem
	return self


func build() -> TerrainDecorationGraphicData:
	return graphic

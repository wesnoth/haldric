class_name TerrainTransitionGraphicBuilder

var graphic := TerrainTransitionGraphicData.new()


func new_graphic() -> TerrainTransitionGraphicBuilder:
	graphic = TerrainTransitionGraphicData.new()
	return self


func with_textures(textures: Dictionary) -> TerrainTransitionGraphicBuilder:
	graphic.textures = textures
	return self


func with_image_stem(image_stem: String) -> TerrainTransitionGraphicBuilder:
	graphic.image_stem = image_stem
	return self


func include(include: Array) -> TerrainTransitionGraphicBuilder:
	graphic.include = include
	return self


func exclude(exclude: Array) -> TerrainTransitionGraphicBuilder:
	graphic.exclude = exclude
	return self


func build() -> TerrainTransitionGraphicData:
	return graphic

class_name TerrainTransitionGraphicBuilder

var graphic := TerrainTransitionGraphicData.new()


func new_graphic() -> TerrainTransitionGraphicBuilder:
	graphic = TerrainTransitionGraphicData.new()
	return self


func with_textures(image_path: String) -> TerrainTransitionGraphicBuilder:
	return self


func include(include: Array) -> TerrainTransitionGraphicBuilder:
	graphic.include = include
	return self


func exclude(exclude: Array) -> TerrainTransitionGraphicBuilder:
	graphic.exclude = exclude
	return self


func build() -> TerrainTransitionGraphicData:
	return graphic

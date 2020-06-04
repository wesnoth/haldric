class_name TerrainGraphicBuilder

var graphic := TerrainGraphicData.new()

func new_graphic() -> TerrainGraphicBuilder:
	graphic = TerrainGraphicData.new()
	return self


func with_texture(texture: Texture) -> TerrainGraphicBuilder:
	graphic.texture = texture
	return self


func with_offset(offset := Vector2()) -> TerrainGraphicBuilder:
	graphic.offset = offset
	return self


func build() -> TerrainGraphicData:
	return graphic

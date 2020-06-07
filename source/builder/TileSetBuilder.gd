class_name TileSetBuilder


static func build(terrain_dict: Dictionary) -> TileSet:
	var tile_set := TileSet.new()

	for key in terrain_dict:
		var terrain : TerrainData = terrain_dict[key]
		var graphic : TerrainGraphicData = terrain.graphic
		var __ = _add_tile(tile_set, key, graphic.texture, graphic.offset)

		for i in graphic.variations.size():
			__ = _add_tile(tile_set, key + str(i + 2), graphic.variations[i], graphic.offset)

	return tile_set


static func _add_tile(tile_set: TileSet, code: String, tex: Texture, offset: Vector2) -> int:
	var tile_id := tile_set.get_tiles_ids().size()
	tile_set.create_tile(tile_id)
	tile_set.tile_set_name(tile_id, code)
	tile_set.tile_set_texture(tile_id, tex)
	tile_set.tile_set_texture_offset(tile_id, offset)

	print("Created Tile " + str(tile_id), ": { Name: " + code + ", Texture: " + str(tex) + "}")

	return tile_id

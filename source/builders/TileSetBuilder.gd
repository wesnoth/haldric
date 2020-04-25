class_name TileSetBuilder

var sheets := {}
var graphics := {}
var transitions := {}

func load_spritesheet(name: String, path: String) -> void:
	var sheet = load(path) as Texture
	sheets[name] = sheet

func create_terrain_graphic(code: String, sheet_name: String, region: Rect2) -> void:

	if not sheets.has(sheet_name):
		print("TileSetBuilder: sheets does not contain %s" % sheet_name)
		return

	var tex = AtlasTexture.new()

	tex.atlas = sheets[sheet_name]
	tex.region = region

	graphics[code] = tex

"""
func create_terrain_transition() -> void:
	pass
"""

func build_terrain_tile_set() -> TileSet:
	var tile_set = TileSet.new()
	for key in graphics:
		var tex = graphics[key]
		_add_tile(tile_set, key, tex, Vector2(0, 0))
	return tile_set

"""
func build_transitions_tile_set() -> TileSet:
	return TileSet.new()
"""

func _add_tile(tile_set: TileSet, code: String, tex: Texture, offset: Vector2) -> void:
	var tile_id := tile_set.get_tiles_ids().size()
	tile_set.create_tile(tile_id)
	tile_set.tile_set_name(tile_id, code)
	tile_set.tile_set_texture(tile_id, tex)
	tile_set.tile_set_texture_offset(tile_id, offset)

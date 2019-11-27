class_name TileSetBuilder

var sheets := {}
var graphics := {}
var transitions := {}

func load_sprite_sheet(name: String, path: String) -> void:
	var sheet = load(path) as Texture
	sheets[name] = sheet

func create_terrain_graphic() -> void:
	pass

func create_terrain_transition() -> void:
	pass

func build_terrain_tile_set() -> TileSet:
	return TileSet.new()

func build_transitions_tile_set() -> TileSet:
	return TileSet.new()

func _add_tile(tile_set: TileSet, code: String, tex: Texture, offset: Vector2) -> void:
	pass

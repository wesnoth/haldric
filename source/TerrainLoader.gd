extends Resource
class_name TerrainLoader

var terrains := {}

var terrain_builder := TerrainBuilder.new()
var graphic_builder := TerrainGraphicBuilder.new()

func load_terrain() -> Dictionary:
	_load()
	return terrains

func add_basic_terrain(name: String, code: String, image_path: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_graphic(graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/" + image_path))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func add_large_terrain(name: String, code: String, image_path: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_graphic(graphic_builder\
			.new_graphic()\
			.with_offset(Vector2(-36, -36))\
			.with_texture(load("graphics/images/terrain/" + image_path))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func add_village_terrain(name: String, code: String, image_path: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_gives_income(true)\
		.with_graphic(graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/" + image_path))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func add_castle_terrain(name: String, code: String, image_path: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_rectuit_onto(true)\
		.with_graphic(graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/" + image_path))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func add_keep_terrain(name: String, code: String, image_path: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_rectuit_onto(true)\
		.with_recruit_from(true)\
		.with_graphic(graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/" + image_path))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func _load() -> void:
	pass

extends Resource
class_name TerrainLoader

var terrains := {}
var transitions := {}

var terrain_builder := TerrainBuilder.new()
var transition_graphic_builder := TerrainTransitionGraphicBuilder.new()
var terrain_graphic_builder := TerrainGraphicBuilder.new()

func load_terrain() -> Dictionary:
	_load()
	return terrains

func new_base(name: String, code: String, type: String, image_path: String, extention := "png", offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/%s.%s" % [image_path, extention]))\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_village(name: String, code: String, type: String, image_path: String, extention := "png", offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_gives_income(true)\
		.with_heals(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/%s.%s" % [image_path, extention]))\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_castle(name: String, code: String, type: String, image_path: String, extention := "png", offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_rectuit_onto(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/%s.%s" % [image_path, extention]))\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_keep(name: String, code: String, type: String, image_path: String, extention := "png", offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_rectuit_onto(true)\
		.with_recruit_from(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(load("graphics/images/terrain/%s.%s" % [image_path, extention]))\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[code] = terrain


func new_transition(code, include: Array, exclude: Array, image_path: String, extention := "png") -> void:
	var transition := transition_graphic_builder\
		.new_graphic()\
		.with_textures(image_path)\
		.include(include)\
		.exclude(exclude)\
		.build()

	if code is String:

		if not transitions.has(code):
			transitions[code] = []

		transitions[code].append(transition)

	elif code is Array:

		for c in code:
			if not transitions.has(c):
				transitions[c] = []

			transitions[c].append(transition)


func _load() -> void:
	pass

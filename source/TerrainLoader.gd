class_name TerrainLoader

var MAX_VARIATION_COUNT := 15

var root := "res://"

var images := {}

var terrains := {}
var transitions := {}

var terrain_builder := TerrainBuilder.new()
var transition_graphic_builder := TerrainTransitionGraphicBuilder.new()
var terrain_graphic_builder := TerrainGraphicBuilder.new()


func load_terrain() -> void:
	_load()


func open_path(path: String) -> void:
	images = {}
	root = path

	for file_data in Loader.load_dir(root, ["png", "tres"]):
		images[file_data.id] = file_data.data

	print(images)


func new_base(name: String, code: String, layer: int, type: String, image_stem: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_layer(layer)\
		.with_type(type)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(images[image_stem])\
			.with_variations(_load_base_variations(image_stem))\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_overlay(name: String, code: String, type: String, image_stem: String, offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(images[image_stem])\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_village(name: String, code: String, type: String, image_stem: String) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_gives_income(true)\
		.with_heals(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(images[image_stem])\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_castle(name: String, code: String, type: String, image_stem: String, offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_rectuit_onto(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(images[image_stem])\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[terrain.code] = terrain


func new_keep(name: String, code: String, type: String, image_stem: String, offset := Vector2()) -> void:
	var terrain := terrain_builder\
		.new_terrain()\
		.with_name(name)\
		.with_code(code)\
		.with_type(type)\
		.with_rectuit_onto(true)\
		.with_recruit_from(true)\
		.with_graphic(terrain_graphic_builder\
			.new_graphic()\
			.with_texture(images[image_stem])\
			.with_offset(offset)\
			.build())\
		.build()

	terrains[code] = terrain


func new_transition(code, include: Array, exclude: Array, image_stem: String, flag := "") -> void:
	var transition := transition_graphic_builder\
		.new_graphic()\
		.with_textures(_load_transitions(code, image_stem, flag))\
		.include(include)\
		.exclude(exclude)\
		.build()

	if code is String:

		if not transitions.has(code):
			transitions[code] = {}

		transitions[code][flag] = transition

	elif code is Array:

		for c in code:
			if not transitions.has(c):
				transitions[c] = {}

			transitions[c][flag] = transition


func _load_base_variations(image_stem: String) -> Array:
	var textures := []

	for i in range(2, MAX_VARIATION_COUNT + 1):
		var variation = image_stem + str(i)

		if images.has(variation):
			textures.append(images[variation])

	return textures


func _load_transitions(code: String, image_stem: String, flag: String) -> Dictionary:
	var directions := [ "-n", "-ne", "-se", "-s", "-sw", "-nw"]
	var textures := {}

	if flag:
		flag = "-" + flag

	for key in images:
		for dir in directions:

			if key.begins_with(image_stem + flag + dir):
				var texture = images[key]
				var key_flags = key.replace(image_stem + flag, "")
				textures[key_flags] = images[key]

	return textures


func _load() -> void:
	pass

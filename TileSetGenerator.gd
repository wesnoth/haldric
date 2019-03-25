tool
extends Node

var images_path := "res://graphics/images/terrain/transitions"
var save_path := "res://graphics/tilesets/transitions.tres"

var CODE = {}
var transition_table = {}

export var generate := false setget _set_generate

func _set_generate(value):
	if Engine.is_editor_hint():
		_setup_terrain_code_table()
		_generate_tile_set()

func _generate_tile_set():

	var Loader = load("res://source/global/Loader.gd").new()

	var transition_images = Loader.load_dir(images_path, ["png"])

	for transition in transition_images:
		var name = transition.id.split("_")[0]
		transition_table[CODE[name]] = {}

	for transition in transition_images:
		var name = transition.id.split("_")[0]
		var direction = transition.id.split("_")[1]
		transition_table[CODE[name]][direction] = (transition.data)

	var tile_set = TileSet.new()

	var id = 0

	for terrain in transition_table:
		for direction in transition_table[terrain]:
			var tile_name = terrain + "_" + direction
			var tile_texture = transition_table[terrain][direction]

			#tile_name)
			#print(transition_table[terrain][direction])

			tile_set.create_tile(id)
			tile_set.tile_set_name(id, tile_name)
			tile_set.tile_set_texture(id, tile_texture)
			id += 1

	ResourceSaver.save(save_path, tile_set)

func _setup_terrain_code_table():
	CODE["green"] = "Gg"
	CODE["dry"] = "Gd"
	CODE["semi-dry"] = "Gs"
	CODE["leaf-litter"] = "Gll"


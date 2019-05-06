tool
extends Node

var images_path := "res://graphics/images/terrain/transitions"
var save_path := "res://graphics/tilesets/transitions.tres"

var CODE := {}
var transition_table := {}

export var generate := false setget _set_generate

func _set_generate(value):
	if Engine.is_editor_hint():
		_setup_terrain_code_table()
		_generate_tile_set()

func _generate_tile_set():
	var Loader: Node = preload("res://source/global/Loader.gd").new()

	var transition_images: Array = Loader.load_dir(images_path, ["png"])

	for transition in transition_images:
		var id_str = transition.id.split("_")
		var path_str = transition.path.split("/")

		var name: String = id_str[0]
		var direction: String = id_str[1]

		var parent_folder: String = path_str[path_str.size() - 2]

		transition_table[CODE["%s-%s" % [parent_folder, name]]] = {
			direction = transition.data
		}

	var tile_set := TileSet.new()

	var id := 0

	for terrain in transition_table:
		for direction in transition_table[terrain]:
			var tile_name = terrain + "_" + direction
			var tile_texture = transition_table[terrain][direction]

			tile_set.create_tile(id)
			tile_set.tile_set_name(id, tile_name)
			tile_set.tile_set_texture(id, tile_texture)
			id += 1

	ResourceSaver.save(save_path, tile_set)

func _setup_terrain_code_table():
	CODE["grass-green"] = "Gg"
	CODE["void-void"] = "Xv"
	CODE["grass-dry"] = "Gd"
	CODE["grass-semi-dry"] = "Gs"
	CODE["grass-leaf-litter"] = "Gll"
	CODE["hills-desert"] = "Hd"
	CODE["hills-regular"] = "Hh"
	CODE["hills-dry"] = "Hhd"
	CODE["hills-snow"] = "Ha"

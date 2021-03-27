extends Node

var DefaultAmla : Advancement = preload("res://data/advancements/Default.tscn").instance()

var terrain_icons = preload("res://data/terrain_icons.tres")

var terrains := {}
var base_overlays := {}
var transitions := {}
var decorations := {}
var wall_segments := {}
var wall_towers := {}

var races := {}
var units := {}
var factions := {}

var scenarios := {}

var AIs := {}


func _ready() -> void:
	scan()


func scan() -> void:
	terrains.clear()
	units.clear()
	races.clear()
	factions.clear()
	scenarios.clear()
	AIs.clear()

	_load_addons("user://addons/")

	_load_terrain("res://data/terrain.gd")
	_load_races("res://data/races")
	_load_units("res://data/units")
	_load_factions("res://data/factions")
	_load_scenarios("res://data/scenarios")
	_load_ais("res://ai")


	var path = "res://addons/"

	var directory := Directory.new()
	directory.make_dir(path)

	if not directory.open(path) == OK:
		print("Loader: failed to load ", path, ", return [] (open)")
		return

	if not directory.list_dir_begin(true, true) == OK:
		print("Loader: failed to load ", path, ", return [] (list_dir_begin)")
		return

	while true:
		var sub_path = directory.get_next()
		print(sub_path)

		if sub_path == "." or sub_path == ".." or sub_path.begins_with("_"):
			continue

		elif sub_path == "":
			break

		_load_terrain(path + sub_path + "/data/terrain.gd")
		_load_races(path + sub_path + "/data/races")
		_load_units(path + sub_path + "/data/units")
		_load_factions(path + sub_path + "/data/factions")
		_load_scenarios(path + sub_path + "/data/scenarios")
		_load_ais(path + sub_path + "/ai")

func _load_addons(path):
	var directory := Directory.new()
	directory.make_dir(path)

	if not directory.open(path) == OK:
		print("Loader: failed to load ", path, ", return [] (open)")
		return []

	if not directory.list_dir_begin(true, true) == OK:
		print("Loader: failed to load ", path, ", return [] (list_dir_begin)")
		return []

	while true:
		var sub_path = directory.get_next()
		print(sub_path)

		if sub_path == "." or sub_path == ".." or sub_path.begins_with("_"):
			continue

		elif sub_path == "":
			break

		ProjectSettings.load_resource_pack(sub_path)

func add_terrain(terrain: TerrainData) -> void:
	terrains[terrain.code] = terrain


func _load_terrain(path) -> void:

	var terrain_script := load(path).new() as TerrainLoader
	terrain_script.load_terrain()

	merge_dict(terrains, terrain_script.terrains)
	merge_dict(base_overlays, terrain_script.base_overlays)
	merge_dict(decorations, terrain_script.decorations)
	merge_dict(transitions, terrain_script.transitions)
	merge_dict(wall_segments, terrain_script.wall_segments)
	merge_dict(wall_towers, terrain_script.wall_towers)

	print("Data:")
	print("Terrains")
	print(terrains)
	print("Base Overlays")
	print(base_overlays)
	print("Decorations")
	print(decorations)
	print("Transitions")
	print(transitions)
	print("Wall Segments")
	print(wall_segments)
	print("Wall Towers")
	print(wall_towers)


static func merge_dict(target, patch):
	for key in patch:
		target[key] = patch[key]


func _load_races(path) -> void:
	for file_data in Loader.load_dir(path, ["tres", "res"]):
		races[file_data.data.id] = file_data.data

	print(races)


func _load_units(path) -> void:
	for file_data in Loader.load_dir(path, ["tscn", "scn"]):
		units[file_data.data.instance().name] = file_data.data

	print(units)


func _load_factions(path) -> void:
	for file_data in Loader.load_dir(path, ["tres", "res"]):
		factions[file_data.data.alias] = file_data.data

	print(factions)


func _load_scenarios(path) -> void:
	for file_data in Loader.load_dir(path, ["tres", "res"]):
		scenarios[file_data.data.id] = file_data.data

	print(scenarios)


func _load_ais(path) -> void:
	for file_data in Loader.load_dir(path, [ "gd", "gdc" ]):
		AIs[file_data.id] = file_data.data

	print(AIs)

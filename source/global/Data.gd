extends Node

var DefaultAmla : Advancement = preload("res://data/advancements/Default.tscn").instance()

var terrain_icons = preload("res://data/terrain_icons.tres")

var terrains := {}
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
	_load_terrain()
	_load_races()
	_load_units()
	_load_factions()
	_load_scenarios()
	_load_ais()


func add_terrain(terrain: TerrainData) -> void:
	terrains[terrain.code] = terrain


func _load_terrain() -> void:
	terrains.clear()

	var terrain_script := load("res://data/terrain.gd").new() as TerrainLoader
	terrain_script.load_terrain()

	terrains = terrain_script.terrains
	decorations = terrain_script.decorations
	transitions = terrain_script.transitions
	wall_segments = terrain_script.wall_segments
	wall_towers = terrain_script.wall_towers

	print("Data:")
	print("Terrains")
	print(terrains)
	print("Decorations")
	print(decorations)
	print("Transitions")
	print(transitions)
	print("Wall Segments")
	print(wall_segments)
	print("Wall Towers")
	print(wall_towers)


func _load_races() -> void:
	races.clear()

	for file_data in Loader.load_dir("res://data/races", ["tres", "res"]):
		races[file_data.data.id] = file_data.data

	print(races)


func _load_units() -> void:
	units.clear()

	for file_data in Loader.load_dir("res://data/units", ["tscn", "scn"]):
		units[file_data.data.instance().name] = file_data.data

	print(units)


func _load_factions() -> void:
	factions.clear()

	for file_data in Loader.load_dir("res://data/factions", ["tres", "res"]):
		factions[file_data.data.alias] = file_data.data

	print(factions)


func _load_scenarios() -> void:
	scenarios.clear()

	for file_data in Loader.load_dir("res://data/scenarios", ["tres", "res"]):
		scenarios[file_data.data.id] = file_data.data

	print(scenarios)


func _load_ais() -> void:
	AIs.clear()

	for file_data in Loader.load_dir("res://ai", [ "gd" ]):
		AIs[file_data.id] = file_data.data

	print(AIs)

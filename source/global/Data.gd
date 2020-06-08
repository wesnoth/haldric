extends Node

var DefaultAmla : Advancement = preload("res://data/advancements/Default.tscn").instance()

var terrains := {}
var transitions := {}

var races := {}
var units := {}

var scenarios := {}

var AIs := {}


func _ready() -> void:
	scan()


func scan() -> void:
	_load_terrain()
	_load_races()
	_load_units()
	_load_scenarios()
	_load_ais()


func add_terrain(terrain: TerrainData) -> void:
	terrains[terrain.code] = terrain


func _load_terrain() -> void:
	terrains.clear()

	var terrain_script := load("res://data/terrain.gd").new() as TerrainLoader
	terrain_script.load_terrain()

	terrains = terrain_script.terrains
	transitions = terrain_script.transitions

	print("Data:")
	print(terrains)
	print(transitions)


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

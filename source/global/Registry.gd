extends Node

var units := {}
var scenarios := {}
var terrain := {}

func _ready() -> void:
	_load_units()
	_load_scenarios()
	_load_terrain()

func _load_units() -> void:
	units = Loader.load_yaml_dir("res://data/units")
	for unit in units.values():
		if unit.has("abilities"):
			unit.abilities = []

func _load_scenarios() -> void:
	scenarios = Loader.load_yaml_dir("res://data/multiplayer/scenarios")

func _load_terrain() -> void:
	terrain = Loader.load_yaml_dir("res://data/terrain")
	terrain = terrain.values()[0]
	for code in terrain:
		terrain[code].code = code
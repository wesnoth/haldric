extends Node

var units := {}
var music := {}
var scenarios := {}
var terrain := {}

func _ready() -> void:
	_load_music()
	_load_units()
	_load_scenarios()
	_load_terrain()

func _load_units() -> void:
	units = Loader.load_dir("res://data/units", Loader.FILE_TYPE.RESOURCE)

func _load_music() -> void:
	music = Loader.load_dir("res://audio/music", Loader.FILE_TYPE.RESOURCE)

func _load_scenarios() -> void:
	scenarios = Loader.load_dir("res://data/multiplayer/scenarios", Loader.FILE_TYPE.RESOURCE)

func _load_terrain() -> void:
	terrain = Loader.load_dir("res://data/terrain_yaml", Loader.FILE_TYPE.TEXT)
	terrain = terrain.values()[0]
	for code in terrain:
		terrain[code].code = code
extends Node

var units := {}
var music := {}
var scenarios := {}
var campaigns := {}
var terrain := {}
var times := {}
var schedules := {}

func _ready() -> void:
	scan()

func scan() -> void:
	_load_music()
	_load_units()
	_load_scenarios()
	_load_campaigns()
	_load_terrain()
	_load_times()
	_load_schedules()

func _load_units() -> void:
	units.clear()

	for file_data in Loader.load_dir("res://data/units", ["tscn", "scn"]):
		var unit_id = file_data.data._bundled.variants[1] # read id variable from packed scene whih inherits UnitType.tscn
		units[unit_id] = file_data.data

func _load_music() -> void:
	music.clear()

	for file_data in Loader.load_dir("res://audio/music", ["ogg", "wav"], false):
		music[file_data.id] = file_data.path

func _load_scenarios() -> void:
	scenarios.clear()

	# load user data first, so core data will overwrite it if there are duplicates
	for file_data in Loader.load_dir("user://data/editor/scenarios", ["tres", "res"]):
		scenarios[file_data.id] = file_data # Save all file data

	for file_data in Loader.load_dir("res://data/scenarios", ["tres", "res"]):
		scenarios[file_data.id] = file_data # Save all file data

func _load_campaigns() -> void:
	campaigns.clear()

	for file_data in Loader.load_dir("res://data/campaigns", ["tres", "res"]):
		campaigns[file_data.id] = file_data

func _load_terrain() -> void:
	terrain.clear()

	for file_data in Loader.load_dir("res://data/terrain", ["tres", "res"]):
		var code = file_data.data.code
		terrain[code] = file_data.data

func _load_times() -> void:
	times.clear()

	for file_data in Loader.load_dir("res://data/times", ["tres", "res"]):
		times[file_data.id] = file_data.data

func _load_schedules() -> void:
	schedules.clear()

	for file_data in Loader.load_dir("res://data/schedules", ["tres", "res"]):
		schedules[file_data.id] = file_data.data

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
	for file_data in Loader.load_dir("res://data/units", ["tscn", "scn"]):
		units[file_data.id] = file_data.data

func _load_music() -> void:
	for file_data in Loader.load_dir("res://audio/music", ["ogg", "wav"]):
		music[file_data.id] = file_data.data

func _load_scenarios() -> void:
	for file_data in Loader.load_dir("res://data/scenarios", ["tres", "res"]):
		scenarios[file_data.id] = file_data # Save all file data

func _load_campaigns() -> void:
	for file_data in Loader.load_dir("res://data/campaigns", ["tres", "res"]):
		campaigns[file_data.id] = file_data

func _load_terrain() -> void:
	for file_data in Loader.load_dir("res://data/terrain", ["tres", "res"]):
		var code = file_data.data.code
		terrain[code] = file_data.data

func _load_times() -> void:
	for file_data in Loader.load_dir("res://data/times", ["tres", "res"]):
		times[file_data.id] = file_data.data

func _load_schedules() -> void:
	for file_data in Loader.load_dir("res://data/schedules", ["tres", "res"]):
		schedules[file_data.id] = file_data.data
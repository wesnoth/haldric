extends Node

var units := {}
var music := {}
var scenarios := {}
var terrain := {}

func _ready() -> void:
	scan()

func scan() -> void:
	_load_music()
	_load_units()
	_load_scenarios()
	_load_terrain()

func _load_units() -> void:
	var directory_data: Array =\
			Loader.load_dir("res://data/units", ["tres", "res"])
	for file_data in directory_data:
		units[file_data.id] = file_data.data

func _load_music() -> void:
	var directory_data: Array =\
			Loader.load_dir("res://audio/music", ["ogg", "wav"])
	for file_data in directory_data:
		music[file_data.id] = file_data.data

func _load_scenarios() -> void:
	var directory_data: Array =\
			Loader.load_dir("res://data/scenarios", ["tres", "res"])
	for file_data in directory_data:
		scenarios[file_data.id] = file_data # Save all file data

func _load_terrain() -> void:
	var directory_data: Array =\
			Loader.load_dir("res://data/terrain", ["tres", "res"])
	for file_data in directory_data:
		var code = file_data.data.code
		terrain[code] = file_data.data

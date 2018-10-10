extends Node

var registry = {}

func load_dir(path, files):
	pass

func load_map(path):
	var map_file = File.new()
	
	if map_file.load(path, File.READ) != OK:
		print("map \"", path, "\" could not be loaded")
	
	else:
		var base = TileMap.new()
		var overlay = TileMap.new()
	pass

func save_map(map):
	pass
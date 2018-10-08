# NOT YET READY!!

extends Node

var registry = {}

func load_dir(path):
	var directory = Directory.new()
	directory.load(path)
	

func get_files_in_directory(path, files):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif current_is_dir():
			pass
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	return files
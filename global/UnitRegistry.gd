extends Node

var yaml_parser = preload("res://addons/godot-yaml/gdyaml.gdns").new()

var registry = {}

func load_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var unit = yaml_parser.parse(file.get_as_text())
		registry[unit.type] = {
			type = unit.type,
			name = unit.name,
			health = unit.health,
			moves = unit.moves,
			image = unit.image,
			attack = unit.attack,
			resistance = unit.resistance
		}

func get_files_in_directory(path, files):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	var sub_path
	while true:
		sub_path = dir.get_next()
		if sub_path == "." or sub_path == "..":
			continue
		if sub_path == "":
			break
		if dir.current_is_dir():
			get_files_in_directory(dir.get_current_dir() + "/" + sub_path, files)
		else:
			var file = File.new()
			print("load unit file: ", dir.get_current_dir() + "/" + sub_path)
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				files.append(file)
	dir.list_dir_end()
	return files

func create(type, side):
	var unit = load("res://units/Unit.tscn").instance()
	unit.initialize(registry[type], side)
	return unit
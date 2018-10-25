extends Node

var yaml_parser = preload("res://addons/godot-yaml/gdyaml.gdns").new()

var units = {}
var abilities = {}
var scenarios = {}

func load_ability_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var script = load(file.data.get_path()).new()
		abilities[file.id] = {}
		abilities[file.id].script = script
		abilities[file.id].function = funcref(script, file.id)

func load_unit_dir(path):
	
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var config = yaml_parser.parse(file.data.get_as_text())
		units[config.id] = config
		if !config.has("abilities"):
			units[config.id].abilities = []

func load_scenario_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var config = yaml_parser.parse(file.data.get_as_text())
		scenarios[config.id] = config
		scenarios[config.id].map_data = MapLoader.load_map(config.map_data)

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
			var file_id = sub_path.split(".")[0]
			print("load file: ", dir.get_current_dir() + "/" + sub_path)
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				files.append({ data = file, id = file_id })
	dir.list_dir_end()
	return files

func validate_advancements():
	for config in units.values():
		if !units.has(config.advances_to) and config.advances_to != null:
			print(config.id, ": Invalid Advancement! ", config.advances_to, " does not exist!")

func create_unit(id, side):
	var unit = load("res://source/Unit.tscn").instance()
	unit.initialize(units[id], side)
	return unit
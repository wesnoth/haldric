extends Node

var yaml_parser = preload("res://addons/godot-yaml/gdyaml.gdns").new()

var units = {}
var scenarios = {}

func load_unit_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var unit = yaml_parser.parse(file.get_as_text())
		units[unit.id] = {
			id = unit.id,
			name = unit.name,
			level = unit.level,
			cost = unit.cost,
			health = unit.health,
			moves = unit.moves,
			experience = unit.experience,
			advances_to = unit.advances_to,
			image = unit.image,
			attacks = unit.attacks,
			resistance = unit.resistance,
			defense = unit.defense,
			movement = unit.movement
		}

func load_scenario_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var scenario = yaml_parser.parse(file.get_as_text())
		print(scenario)
		scenarios[scenario.id] = {
			name = scenario.name,
			id = scenario.id,
			map_data = MapLoader.load_map(scenario.map_data),
			turns = scenario.turns,
			sides = scenario.sides
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
			print("load file: ", dir.get_current_dir() + "/" + sub_path)
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				files.append(file)
	dir.list_dir_end()
	return files

func validate_advancements():
	for unit in units.values():
		if !units.has(unit.advances_to) and unit.advances_to != null:
			print(unit.id, ": Invalid Advancement! ", unit.advances_to, " does not exist!")

func create_unit(id, side):
	var unit = load("res://units/Unit.tscn").instance()
	unit.initialize(units[id], side)
	return unit
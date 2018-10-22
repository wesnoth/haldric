extends Node

var registry = {}

func load_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var unit = parse_json(file.get_as_text())
		registry[unit.id] = {
			id = unit.id,
			name = unit.name,
			level = unit.level,
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

func validate_advancements():
	for unit in registry.values():
		if !registry.has(unit.advances_to) and unit.advances_to != null:
			print(unit.id, ": Invalid Advancement! ", unit.advances_to, " does not exist!")

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

func create(id, side):
	var unit = load("res://units/Unit.tscn").instance()
	unit.initialize(registry[id], side)
	return unit
extends Node

var YAML = preload("res://addons/godot-yaml/gdyaml.gdns").new()

func load_map(path : String) -> Map:
	var map := Map.new()
	var file = File.new()
	
	if not file.open(path, file.READ) == OK:
		print("Loader: failed to load ", path, ", return null")
		file.close()
		return null
	
	var y = 0
	while not file.eof_reached():
		var line = file.get_csv_line()
		for x in range(line.size()):
			var item = line[x].strip_edges().split("^")
			var base = item[0]
			var id = map.tile_set.find_tile_by_name(base)
			map.set_cell(x, y, id)
			if (item.size() == 2):
				var overlay_id = map.tile_set.find_tile_by_name("^" + item[1])
				map.overlay.set_cell(x, y, overlay_id)
		y += 1
	
	file.close()
	return map

func load_resource_dir(path : String) -> Dictionary:
	var directory_data := load_dir(path)
	var dict := {}
	
	for file_data in directory_data:
		var resource : Resource = load(file_data.path)
		dict[file_data.id] = resource
	
	return dict

func load_yaml_dir(path : String) -> Dictionary:
	var directory_data := load_dir(path)
	var dict := {}
	
	for file_data in directory_data:
		var config : Dictionary = YAML.parse(file_data.text)
		dict[file_data.id] = config
	
	return dict

func load_dir(path : String) -> Array:
	return _get_file_data_in_directory(path, [])

func _get_file_data_in_directory(path : String, directory_data : Array) -> Array:
	
	var directory := Directory.new()
	
	if not directory.open(path) == OK:
		print("Loader: failed to load ", path, ", return [] (open)")
		return []
	
	if not directory.list_dir_begin(true, true) == OK:
		print("Loader: failed to load ", path, ", return [] (list_dir_begin)")
		return []
	
	var sub_path := ""
	
	while true:
		sub_path = directory.get_next()
		
		if sub_path == "." or sub_path == "..":
			continue
		
		elif sub_path == "":
			break
		
		elif directory.current_is_dir():
			directory_data = _get_file_data_in_directory(directory.get_current_dir() + "/" + sub_path, directory_data)
		
		else:
			var file_data = _get_file_data(directory.get_current_dir() + "/" + sub_path, sub_path)
			directory_data.append(file_data)
	
	directory.list_dir_end()
	return directory_data

func _get_file_data(path : String, file_name : String) -> Dictionary:
	
	var file := File.new()
	var file_id := file_name.split(".")[0]
	var file_data := {}

	if not file.open(path, file.READ) == OK:
		print("Loader: failed to load file: ", path, ", return {}")
		file.close()
		return file_data
	
	file_data = { text = file.get_as_text(), id = file_id, path = path}
	print("Loader: load file: ", path)
	
	file.close()
	return file_data
extends Node

var YAML = preload("res://addons/godot-yaml/gdyaml.gdns").new()

func load_yaml_dir(path : String) -> Dictionary:
	var directory_data := load_dir(path)
	var dict := {}
	
	for file_data in directory_data:
		var config : Dictionary = YAML.parse(file_data.text)
		dict[config.id] = config
	
	return dict

func load_dir(path : String) -> Array:
	return _get_file_data_in_directory(path, [])

func load_file(path : String) -> Dictionary:
	return _get_file_data(path)

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
			var file_data = _get_file_data(directory.get_current_dir() + "/" + sub_path)
			directory_data.append(file_data)
	
	directory.list_dir_end()
	return directory_data

func _get_file_data(path : String) -> Dictionary:
	
	var file := File.new()
	var file_id := path.split(".")[0]
	var file_data := {}
	
	if file.open(path, file.READ) == OK:
		file_data = { text = file.get_as_text(), id = file_id }
		
		print("Loader: load file: ", path)
	
	else:
		file_data = {}
		
		print("Loader: failed to load file: ", path, ", return {}")
	
	file.close()
	return file_data
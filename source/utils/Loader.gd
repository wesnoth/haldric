class_name Loader extends Node


static func load_file(path : String) -> Dictionary:
	return _get_file_data(path)


static func load_dir(path : String) -> Array:
	return _get_file_data_in_directory(path, [])


static func _get_file_data_in_directory(path : String, directory_data : Array) -> Array:
	
	var directory := Directory.new()
	
	if not directory.dir_exists(path) or not directory.open(path) == OK:
		print("Loader: failed to load ", path, ", return []")
		return []
	
	directory.list_dir_begin(true, true)
	
	var sub_path := ""
	
	while true:
		sub_path = directory.get_next()
		
		if sub_path == "." or sub_path == "..":
			continue
		
		elif sub_path == "":
			break
		
		elif directory.current_is_dir():
			_get_file_data_in_directory(directory.get_current_dir() + "/" + sub_path, directory_data)
		
		else:
			var file_data = _get_file_data(directory.get_current_dir() + "/" + sub_path)
			directory_data.append(file_data)
	
	directory.list_dir_end()
	return directory_data


static func _get_file_data(path : String) -> Dictionary:
	
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
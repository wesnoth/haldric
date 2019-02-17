class_name Loader extends Node

static func load_dir(path : String) -> Array:
	return _get_file_data_in_directory(path, [])

static func _get_file_data_in_directory(path : String, data : Array) -> Array:
	
	var directory := Directory.new()
	
	if not directory.dir_exists(path):
		print("Loader: failed to load ", path, ", return []")
		return []
	
	directory.open(path)
	directory.list_dir_begin(true, true)
	
	var sub_path := ""
	
	while true:
		sub_path = directory.get_next()
		
		if sub_path == "." or sub_path == "..":
			continue
		
		elif sub_path == "":
			break
		
		elif directory.current_is_dir():
			_get_file_data_in_directory(directory.get_current_dir() + "/" + sub_path, data)
		
		else:
			var file := File.new()
			var file_id := sub_path.split(".")[0]
			
			if file.open(directory.get_current_dir() + "/" + sub_path, file.READ) == OK:
				data.append({ text = file.get_as_text(), id = file_id })
				
				print("Loader: load file: ", directory.get_current_dir() + "/" + sub_path)
			
			file.close()
	
	directory.list_dir_end()

	return data
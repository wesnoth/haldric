class_name FileLoader extends Node

func _get_files_in_directory(path : String, files : Array) -> Array:
	
	var dir := Directory.new()
	
	dir.open(path)
	dir.list_dir_begin(true, true)
	
	var sub_path := ""
	
	while true:
		sub_path = dir.get_next()
		
		if sub_path == "." or sub_path == "..":
			continue
		
		if sub_path == "":
			break
		
		if dir.current_is_dir():
			_get_files_in_directory(dir.get_current_dir() + "/" + sub_path, files)
		
		else:
			var file := File.new()
			var file_id := sub_path.split(".")[0]
			
			print("load file: ", dir.get_current_dir() + "/" + sub_path)
			
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				files.append({ data = file, id = file_id })
	
	dir.list_dir_end()
	
	return files
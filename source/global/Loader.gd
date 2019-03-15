extends Node

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

func load_dir(path : String, extentions : Array) -> Array:
	return _get_directory_data(path, [], extentions)

func _get_directory_data(path : String, directory_data : Array, extentions : Array) -> Array:
	
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
		
		if sub_path == "." or sub_path == ".." or sub_path.begins_with("_"):
			continue
		
		elif sub_path == "":
			break
		
		elif directory.current_is_dir():
			directory_data = _get_directory_data(directory.get_current_dir() + "/" + sub_path, directory_data, extentions)
		
		else:
			if not extentions.has(sub_path.get_extension()):
				continue
			
			var file_data = _get_file_data(directory.get_current_dir() + "/" + sub_path)
			directory_data.append(file_data)
	
	directory.list_dir_end()
	return directory_data

func _get_file_data(path : String) -> Dictionary:
	var file_data := {}
	
	var file_name_extention := path.get_file()
	var file_name := file_name_extention.split(".")[0]
	
	file_data = { 
		id = file_name,
		data = load(path)
	}
	
	if file_data.data:
		print("Loader: load file: ", path)
	else:
		print("Loader: could not load file: ", path)
	return file_data
extends Node

func load_dir(path: String, extentions: Array) -> Array:
	return _get_directory_data(path, [], extentions)

func _get_directory_data(
		path: String, directory_data: Array, extentions: Array) -> Array:
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
			directory_data = _get_directory_data(directory.get_current_dir() +
					"/" + sub_path, directory_data, extentions)
		else:
			if not extentions.has(sub_path.get_extension()):
				continue

			var file_data: Dictionary = _get_file_data(\
					directory.get_current_dir() + "/" + sub_path)
			directory_data.append(file_data)

	directory.list_dir_end()

	return directory_data

func _get_file_data(path: String) -> Dictionary:
	var file_name := path.get_file()
	var file_name_split := file_name.split(".")

	var file_data := {
		id = file_name_split[0], # Name, no extension
		base_path = path.get_basename(), # Full path, no extension
		data = load(path)
	}

	if file_data.data:
		print("Loader: load file: ", path)
	else:
		print("Loader: could not load file: ", path)

	return file_data

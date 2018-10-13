extends Node

var macros = {}

# #
# Loops recursively over all files in the provided path.
# The header is the first line of the macro, which contains the list of argument names.
# Everything else is the text of the macro to be substituted in.
# #
func load_dir(path):
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
			load_dir(dir.get_current_dir() + "/" + sub_path)
		else:
			var file = File.new()
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				var contents = file.get_as_text().split("\n")
				
				macros[sub_path.split(".")[0]] = {}
				macros[sub_path.split(".")[0]].header = contents[0]
				contents.remove(0)
				macros[sub_path.split(".")[0]].text = contents
	dir.list_dir_end()

# #
# Checks each line to see if it contains the "{" character.
# If yes, then either substitute in a multi-line macro text or a single inline value
# #
func substitute(contents):
	var lines = contents.split("\n")
	var length = lines.size()
	var i = 0
	
	while i < length:
		if(lines[i].find("{") != -1):
# if there are no non-whitespace leading characters, get the indentation and prepend that to all lines substituted in over the macro
			if(lines[i].dedent().find("{") == 0):
				var indent = lines[i].substr(0, lines[i].find("{"))
				var macro = get_name(lines[i])
				var ids = get_ids(macros[macro].header)
				set_id_values(lines[i].dedent(), ids)
				
				lines.remove(i)
				for j in macros[macro].text.size():
					lines.insert(i+j, indent+macros[macro].text[j])
					for key in ids.keys():
						if lines[i+j].find("{"+key+"}") != -1:
							lines[i+j] = lines[i+j].replace("{"+key+"}", ids[key])
				
				length = lines.size()
				i = i -1
# otherwise, this is an inline replacement so just drop in the value
			else:
				var macro = get_name(lines[i])
				lines[i] = lines[i].replace("{"+macro+"}", macros[macro].text[0])
		i = i + 1
	
	contents = ""
	for line in lines:
		if line.dedent().length() != 0:
			contents = contents + line + "\n"
	return contents

# #
# Retrieves the name of the macro from the line of text.
# #
func get_name(line):
	line = line.dedent()
	var name_start = line.find("{")+1
	var name_length = line.find(" ", name_start)-1
	if name_length == -2:
		name_length = line.find("}")-name_start
	return line.substr(name_start, name_length)

# #
# Retrieves the substitution arguments from the first line of the macro.
# #
func get_ids(header):
	var ids = {}
	var ids_list = header.split(" ")
	
	ids_list.remove(0)
	for id in ids_list:
		ids[id] = ""
	
	return ids

# #
# Sets what values to use in place of the macro arguments.
# TODO: support values containing spaces
# #
func set_id_values(line, ids):
	var values = line.split("}")[0].split(" ")
	var keys = ids.keys()
	
	values.remove(0)
	for i in keys.size():
		ids[keys[i]] = values[i]
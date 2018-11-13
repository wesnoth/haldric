extends TileMap

enum DIR {SE = 0, NE = 1, N = 2, NW = 3, SW = 4, S = 5}

const SHADER = preload("res://test/transitions/shaders/transition.shader")

var size = Vector2(0, 0)

var terrain_table = {}
var terrain = self

var alpha_table = [
	[
		preload("res://test/transitions/images/alpha/Grass_abrupt_se.png"),
		preload("res://test/transitions/images/alpha/Grass_abrupt_ne.png"),
		preload("res://test/transitions/images/alpha/Grass_abrupt_n.png"),
		preload("res://test/transitions/images/alpha/Grass_abrupt_nw.png"),
		preload("res://test/transitions/images/alpha/Grass_abrupt_sw.png"),
		preload("res://test/transitions/images/alpha/Grass_abrupt_s.png"),
	],
	[
		preload("res://test/transitions/images/alpha/Grass_medium_se.png"),
		preload("res://test/transitions/images/alpha/Grass_medium_ne.png"),
		preload("res://test/transitions/images/alpha/Grass_medium_n.png"),
		preload("res://test/transitions/images/alpha/Grass_medium_nw.png"),
		preload("res://test/transitions/images/alpha/Grass_medium_sw.png"),
		preload("res://test/transitions/images/alpha/Grass_medium_s.png"),
	]
]
var neighbor_table = [
	# EVEN col, ALL rows
    [
		Vector2(+1,  0), # SE
		Vector2(+1, -1), # NE
		Vector2(0, -1), # N
     	Vector2(-1, -1), # NW
		Vector2(-1,  0), # SW
		Vector2(0, +1) # S
	],
	# ODD col, ALL rows
    [
		Vector2(+1, +1), # SE
		Vector2(+1,  0), # NE
		Vector2(0, -1), # N
     	Vector2(-1,  0), # NW
		Vector2(-1, +1), # SW
		Vector2( 0, +1) # S
	]]

func _ready():
	tile_set = TileSet.new()
	randomize()
	
	load_terrain_dir("res://test/transitions/json")
#	load_map("res://test/transitions/test.map")
	generate_map(50, 50)
	load_transitions()

func generate_map(width, height):
	for y in range(height):
		for x in range(width):
			var rand = randi() % terrain_table.values().size()
			var code = terrain_table.values()[rand].id
			var index = int(y * width + x)
			add_tile(index, terrain_table[code])
			set_cell(x, y, index)

	size = Vector2(width, height)

func load_map(path):
	var file = File.new()
	file.open(path, file.READ)

	var y = 0
	while not file.eof_reached():
		var line = file.get_csv_line()
		for x in range(line.size()):
			var index = int(y * line.size() + x)
			var code = line[x].strip_edges()
			add_tile(index, terrain_table[code])
			set_cell(x, y, index)
		y += 1
	file.close()
	size = Vector2(get_used_rect().size)

func load_transitions():
	for cell in get_used_cells():
		var id = int(cell.y * size.x + cell.x)
		var code = tile_set.tile_get_name(id)
		var mat = ShaderMaterial.new()
		
		mat.shader = SHADER
		
		var index = 0
		for n_cell in get_neighbors(cell):
			var n_id = get_cellv(n_cell)

			if n_id == TileMap.INVALID_CELL:
				index += 1
				continue

			var n_code = tile_set.tile_get_name(n_id)
			var terrain = terrain_table[n_code]

			var layer = terrain_table[code].layer
			var n_layer = terrain_table[n_code].layer
			if n_layer > layer:
				mat.set_shader_param(str("tex", index), terrain.image)
				mat.set_shader_param(str("mask", index), alpha_table[randi() % 2][index])
				tile_set.tile_set_material(id, mat)
			index += 1

func add_tile(index, terrain):
	create_tile(index)
	tile_set_name(index, terrain.id)
	tile_set_texture(index, terrain.image)

func create_tile(index):
	tile_set.create_tile(index)

func tile_set_name(index, id):
	tile_set.tile_set_name(index, id)

func tile_set_texture(index, image):
	tile_set.tile_set_texture(index, image)

func get_neighbor(cell, direction):
	var parity = int(cell.x) & 1
	var dir = neighbor_table[parity][direction]
	return Vector2(cell.x + dir[0], cell.y + dir[1])

func get_neighbors(cell):
	var neighbors = []
	var parity = int(cell.x) & 1
	for n in neighbor_table[parity]:
		neighbors.append(Vector2(cell.x + n.x, cell.y+n.y))
	return neighbors

###############################################################
###############################################################

func load_terrain_dir(path):
	var files = []
	files = get_files_in_directory(path, files)
	for file in files:
		var config = JSON.parse(file.data.get_as_text()).result
		for key in config.keys():
			var terrain = config[key]
			terrain_table[key] = terrain
			terrain_table[key].id = key
			terrain_table[key].layer = terrain.layer
			terrain_table[key].image = load(terrain.image)

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
			var file_id = sub_path.split(".")[0]
			print("load file: ", dir.get_current_dir() + "/" + sub_path)
			if file.open(dir.get_current_dir() + "/" + sub_path, file.READ) == OK:
				files.append({ data = file, id = file_id })
	dir.list_dir_end()
	return files
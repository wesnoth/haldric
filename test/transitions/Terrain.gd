extends Node2D

enum DIRECTION { N = 0, NE = 1, SE = 2, S = 3, SW = 4, NW = 5}

const SHADER = preload("res://test/transitions/shaders/transition.shader")

const DIR = {}

var size = Vector2(0,0)

var terrain_table = {}

var alpha_table = []

var neighbor_table = [
	# EVEN col, ALL rows
    [
		Vector2(0, -1), # N
		Vector2(+1, -1), # NE
		Vector2(+1,  0), # SE
		Vector2(0, +1), # S
		Vector2(-1,  0), # SW
		Vector2(-1, -1) # NW
	],
	# ODD col, ALL rows
    [
		Vector2(0, -1), # N
		Vector2(+1,  0), # NE
		Vector2(+1, +1), # SE
		Vector2( 0, +1), # S
		Vector2(-1, +1), # SW
		Vector2(-1,  0) # NW
	]]

var terrain

var tiles = {}

onready var container = $Container

func _ready():
	DIR[S] = "s"
	DIR[SW] = "sw"
	DIR[NW] = "nw"
	DIR[N] = "n"
	DIR[NE] = "ne"
	DIR[SE] = "se"

	terrain = TileMap.new()
	terrain.cell_size = Vector2(384, 512)
	terrain.cell_half_offset = TileMap.HALF_OFFSET_Y
	
	# randomize()
	
	load_terrain_dir("res://test/transitions/json")
	
	generate_map(100, 100)
	
	load_alpha_table()
	load_transitions()

func generate_map(width, height):
	size = Vector2(width, height)
	
	for y in range(height):
		var tile_map = add_tile_map()
		for x in range(width):
			var rand = randi() % terrain_table.values().size()
			var code = terrain_table.values()[rand].id
			var map_id = flatten(x, y)
			add_tile(tile_map.tile_set, x, terrain_table[code])
			tile_map.set_cell(x, y, x)
			
			tiles[map_id] = {
				terrain_code = code,
				layer = terrain_table[code].layer,
				map_id = map_id,
				row_id = x
			}

func load_transitions():
	var y = 0
	for map_row in container.get_children():
		var x = 0
		for cell in map_row.get_used_cells():
			var id = flatten(x, y)
			var tile = tiles[id]
			
			var mat = ShaderMaterial.new()
			mat.shader = SHADER
			
			var neighbors = get_neighbors(cell)
			var n = 0
			var chain = 0
			for n_cell in neighbors:
				var n_id = flattenv(n_cell)
				
				if !tiles.has(n_id) or n < chain:
					n += 1
					continue

				var n_tile = tiles[n_id]
				
				if tile.layer >= n_tile.layer:
					n += 1
					continue
				
				var cfg = terrain_table[tiles[n_id].terrain_code]
				print("[", y, "][", x, "]")
				chain = chain(neighbors, n)
				mat = setup_shader(mat, cfg.image, n, chain)
				map_row.tile_set.tile_set_material(tile.row_id, mat)
				n += 1
			x += 1
		y += 1

func chain(neighbors, start):
	var code = tiles[flattenv(neighbors[start])].terrain_code

	for i in range(6):
		var cell = neighbors[(start + i + 1) % 6 ]
		var index = flattenv(cell)
		if !tiles.has(index):
			return i
		elif code != tiles[index].terrain_code:
			return i
	return 5

func setup_shader(mat, image, direction, chain):
	var rand = randi()%2
	mat.set_shader_param(str("tex", direction), image)
	mat.set_shader_param(str("mask", direction), alpha_table[rand][direction][chain][1])
	print(alpha_table[rand][direction][chain][0], " on ",  DIR[direction])
	return mat

func load_alpha_table():
	for n in range(2):
		alpha_table.append([])
		for i in range(6):
			alpha_table[n].append([])
			for j in range(6):
				alpha_table[n][i].append([])
				alpha_table[n][i][j].append(null)
				alpha_table[n][i][j].append(null)
	print("[", alpha_table.size(), "][", alpha_table[0].size(), "][", alpha_table[0][0].size(), "][", alpha_table[0][0][0].size(), "]")
	
	for start in range(6):
		var append = ""
		for follow in range(6):
			if start != DIRECTION.N and follow == 5:
				continue
			if follow > 0:
				append += str("-", DIR[(start+follow)%6])
			else:
				append += DIR[(start+follow)%6]
			alpha_table[0][start][follow][0] = append
			alpha_table[0][start][follow][1] = load(str("res://test/transitions/images/alpha/Grass_abrupt_", append,".png"))
			alpha_table[1][start][follow][0] = append
			alpha_table[1][start][follow][1] = load(str("res://test/transitions/images/alpha/Grass_medium_", append,".png"))
			# print("[0]", "[", start, "]", "[", follow, "]", alpha_table[0][start][follow][0])
			# print("[1]", "[", start, "]", "[", follow, "]", alpha_table[1][start][follow][0])

func add_tile(tile_set, index, terrain):
	tile_set.create_tile(index)
	tile_set.tile_set_name(index, terrain.id)
	tile_set.tile_set_texture(index, terrain.image)

func add_tile_map():
	var map = TileMap.new()
	map.cell_size = Vector2(384, 512)
	map.cell_half_offset = TileMap.HALF_OFFSET_Y
	map.tile_set = TileSet.new()
	container.add_child(map)
	return map

func get_neighbors(cell):
	var neighbors = []
	var parity = int(cell.x) & 1
	for n in neighbor_table[parity]:
		neighbors.append(Vector2(cell.x + n.x, cell.y+n.y))
	return neighbors

######################################################################
######################################################################

func flattenv(cell):
	return int(cell.y * size.x + cell.x)

func flatten(x, y):
	return int(y * size.x + x)

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
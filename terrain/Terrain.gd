extends TileMap

const village_id = 10

enum DIRECTION {SE, NE, N, NW, SW, S}

export (int) var WIDTH = 20
export (int) var HEIGHT = 15

var offset = Vector2(36, 36)

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

var tiles = {}
var grid = AStar.new()

onready var overlay = $"Overlay"

func _ready():
	_generate_tiles()
	_generate_points()
	_generate_point_connections()

# P U B L I C   F U N C T I O N S


func find_path_by_position(_start_position, _end_position):
	var start_cell = world_to_map(_start_position)
	var end_cell = world_to_map(_end_position)
	return find_path_by_cell(start_cell, end_cell)

func find_path_by_cell(start_cell, end_cell):
	var path2D = []
	if check_boundaries(start_cell) and check_boundaries(end_cell):
		var path3D = grid.get_point_path(flatten_v(start_cell), flatten_v(end_cell))
		for point in path3D:
			path2D.append(Vector2(point.x, point.y))
	return path2D

func get_reachable_cells_u(unit):
	var reachable = get_reachable_cells(world_to_map(unit.position), unit.current_moves)
	return reachable

func get_reachable_cells(_start_cell, _range):
	var start_cube = v2_to_v3(_start_cell)
	var reachable = []
	for cell in get_used_cells():
		var cube = v2_to_v3(cell)
		var diff_x = abs(start_cube.x - cube.x)
		var diff_y = abs(start_cube.y - cube.y)
		var diff_z = abs(start_cube.z - cube.z)
		if max(max(diff_x, diff_y), diff_z) > _range or tiles[flatten_v(cell)].is_blocked:
			continue
		reachable.append(cell)
	return reachable

func are_neighbors(cell1, cell2):
	var cell1_neighbors = _get_neighbors(cell1)
	
	for n in cell1_neighbors:
		if cell2 == n:
			return true
	return false

func unblock_cell(cell):
	tiles[flatten_v(cell)].is_blocked = false

func block_cell(cell):
	tiles[flatten_v(cell)].is_blocked = true

func connect_cell(cell):
	_connect_with_neighbors(cell)

func disconnect_cell(cell):
	_disconnect_with_neighbors(cell)

func map_to_world_centered(_cell):
	var pos = map_to_world(_cell)
	return pos + offset

func world_to_world_centered(_position):
	_position = map_to_world_centered(world_to_map(_position))
	return _position

func flatten_v(_cell):
	return int(_cell.y) * WIDTH + int(_cell.x)

func flatten(_x, _y):
	return int(_y) * WIDTH + int(_x)

func check_boundaries(cell):
	return (cell.x >= 0 and cell.y >= 0 and cell.x < WIDTH  and cell.y < HEIGHT) 

# P R I V A T E   F U N C T I O N S


func _generate_tiles():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var id = flatten(x, y)
			
			var code = tile_set.tile_get_name(get_cell(x, y)) 
			var overlay_code = ""
			
			var overlay_cell = overlay.get_cell(x, y)
			
			if overlay_cell != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay_cell)
			
			var type
			
			if overlay_code == "^Vh":
				type = "village"
			elif overlay_code == "^Fp" or overlay_code == "^Fdf" or overlay_code == "^Fmf" or overlay_code == "^Fds" or overlay_code == "^Fmw":
				type = "forest"
			elif code == "Gg" or code == "Gd" or code == "Gs" or code == "Gll":
				type = "flat"
			elif code == "Hh" or code == "Ha" or code == "Hd" or code == "Hhd":
				type = "hills"
			elif code == "Mm" or code == "Md" or code == "Ms":
				type = "mountains"
			
			tiles[id] = {
				terrain_type = type,
				terrain_code = code + overlay_code,
				is_village = overlay.get_cell(x, y) == village_id,
				is_blocked = false
			}
			
			# print(code, overlay_code)

func _generate_points():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = Vector2(x, y)
			var id = flatten(x, y)
			var point = grid.add_point(id, Vector3(x, y, 0))

func _generate_point_connections():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = Vector2(x, y)
			var id = flatten(x, y)
			var point = grid.get_point_position(id)
			_connect_with_neighbors(cell)

func _connect_with_neighbors(_cell):
	var id = flatten_v(_cell)
	var neighbors = _get_neighbors(_cell)
	for n in neighbors:
		var n_id = flatten(n.x, n.y)
		if check_boundaries(n) and !grid.are_points_connected(id, n_id):
			if !tiles[id].is_blocked and !tiles[n_id].is_blocked:
				grid.connect_points(id, n_id)

func _disconnect_with_neighbors(_cell):
	var id = flatten_v(_cell)
	var neighbors = _get_neighbors(_cell)
	for n in neighbors:
		var n_id = flatten(n.x, n.y)
		if check_boundaries(n) and !grid.are_points_connected(id, n_id):
			grid.disconnect_points(id, n_id)

func _get_neighbor(cell, direction):
	var parity = cell.x & 1
	var dir = neighbor_table[parity][direction]
	return Vector2(cell.x + dir[0], cell.y + dir[1])

func _get_neighbors(cell):
	var neighbors = []
	var parity = int(cell.x) & 1
	for n in neighbor_table[parity]:
		neighbors.append(Vector2(cell.x + n.x, cell.y+n.y))
	return neighbors

func v3_to_v2(cube):
    var col = cube.x
    var row = cube.z + (cube.x - (int(cube.x) & 1)) / 2
    return Vector2(col, row)

func v2_to_v3(hex):
    var x = hex.x
    var z = hex.y - (hex.x - (int(hex.x) & 1)) / 2
    var y = -x-z
    return Vector3(x, y, z)
extends TileMap

enum DIRECTION {SE, NE, N, NW, SW, S}

export (int) var WIDTH = 19
export (int) var HEIGHT = 9

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

func _ready():
	_generate_tiles()
	_generate_points()
	_generate_point_connections()


# P U B L I C   F U N C T I O N S

func get_cell_position_at_mouse_position():
	return world_to_grid(get_local_mouse_position())
	
func world_to_grid(_position):
	return map_to_world(world_to_map(_position))

func world_to_grid_centered(_position):
	var cell = world_to_map(_position)
	if int(cell.x) & 1 == 1:
		return world_to_world(_position) + offset + offset.y
	return world_to_world(_position) + offset

func flatten_v(_cell):
	return int(_cell.y) * WIDTH + int(_cell.x)

func flatten(_x, _y):
	return int(_y) * WIDTH + int(_x)

func check_boundaries(_point):
	return (_point.x >= 0 and _point.y >= 0 and _point.x < WIDTH  and _point.y < HEIGHT)


# P R I V A T E   F U N C T I O N S


func _generate_tiles():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var id = flatten(x, y)
			tiles[id] = {
				cell = Vector2(x, y),
				type = get_cell(x, y),
				weight = 1,
				is_blocked = false,
			}

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
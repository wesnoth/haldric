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

var path = []

onready var unit = $"../Sprite"
onready var move_handler = $"../MoveHandler"

func _ready():
	_generate_tiles()
	_generate_points()
	_generate_point_connections()

var mouse_left

func _input(event):
	mouse_left = Input.is_action_just_pressed("mouse_left")
	
	var mouse_cell = world_to_map(get_global_mouse_position())
	var unit_cell = world_to_map(unit.get_position())
	
	if event and InputEventMouseButton:
		if mouse_left:
			path = find_path_by_cell(unit_cell, mouse_cell)
			move_handler.move_unit(unit, path)
		
		
#		var direction = _get_move_direction()
#		var velocity = direction * SPEED * delta
#		#print(velocity)
#		token.position += velocity.floor()
#		if token.position * direction > map.map_to_world_centered(path[0]) * direction:
#			emit_signal("path_changed")
#			last_point = path[0]
#			path.remove(0)
#			match_._center_position(token)
#			if path.size() == 0:
#				token = null
#				emit_signal("token_arrived")


# P U B L I C   F U N C T I O N S


func find_path_by_position(_start_position, _end_position):
	var start_cell = world_to_map(_start_position)
	var end_cell = world_to_map(_end_position)
	return find_path_by_cell(start_cell, end_cell)

func find_path_by_cell(_start_cell, _end_cell):
	var path3D = grid.get_point_path(_flatten_v(_start_cell), _flatten_v(_end_cell))
	var path2D = []
	for point in path3D:
		path2D.append(Vector2(point.x, point.y))
	if !path2D.empty():
			path2D.remove(0)
	return path2D

func get_reachable_cells_t(_unit):
	var reachable = get_reachable_cells(world_to_map(_unit.position), _unit.actions)
	return reachable

func get_reachable_cells(_start_cell, _range):
	var reachable = []
	for cell in get_used_cells():
		var diff_x = abs(_start_cell.x - cell.x)
		var diff_y = abs(_start_cell.y - cell.y)
		if diff_x + diff_y > _range or tiles[_flatten_v(cell)].is_blocked:
			continue
		reachable.append(cell)
	return reachable

func map_to_world_centered(_cell):
	var pos = map_to_world(_cell)
	return pos + offset

func world_to_world_centered(_position):
	_position = map_to_world_centered(world_to_map(_position))
	return _position

# P R I V A T E   F U N C T I O N S


func _generate_tiles():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var id = _flatten(x, y)
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
			var id = _flatten(x, y)
			var point = grid.add_point(id, Vector3(x, y, 0))

func _generate_point_connections():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = Vector2(x, y)
			var id = _flatten(x, y)
			var point = grid.get_point_position(id)
			_connect_with_neighbors(cell)

func _connect_with_neighbors(_cell):
	var id = _flatten_v(_cell)
	var neighbors = _get_neighbors(_cell)
	for n in neighbors:
		var n_id = _flatten(n.x, n.y)
		if _check_boundaries(n) and !grid.are_points_connected(id, n_id):
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

func _flatten_v(_cell):
	return int(_cell.y) * WIDTH + int(_cell.x)

func _flatten(_x, _y):
	return int(_y) * WIDTH + int(_x)

func _check_boundaries(_point):
	return (_point.x >= 0 and _point.y >= 0 and _point.x < WIDTH  and _point.y < HEIGHT) 
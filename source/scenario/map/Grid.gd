extends AStar
class_name Grid

var rect := Rect2()
var map: TileMap = null

var base_hex_size = Vector2(1, sqrt(3)/2)
var hex_size
var hex_transform
var hex_transform_inv

func _init(new_map: TileMap, map_rect: Rect2) -> void:
	map = new_map
	rect = map_rect

	_generate_points()
	_generate_point_connections()



func find_path_by_location(start_loc: Location, end_loc: Location) -> PoolVector2Array:
	var path2D := PoolVector2Array()
	var path3D: PoolVector3Array = get_point_path(start_loc.id, end_loc.id)
	for point in path3D:
		path2D.append(Vector2(point.x, point.y))

	return path2D

func make_cell_one_way(cell: Vector2):
	var id: int = _flatten(cell)
	var neighbors = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)
		if rect.has_point(n) and are_points_connected(id, n_id):
			disconnect_points(id, n_id)
			connect_points(n_id,id,false)

func block_cell(cell: Vector2):
	_disconnect_with_neighbors(cell)

func unblock_cell(cell: Vector2):
	_disconnect_with_neighbors(cell)
	_connect_with_neighbors(cell)

func _generate_points() -> void:
	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id := _flatten(cell)

			add_point(id, Vector3(x, y, 0))

func _generate_point_connections() -> void:
	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)
			var point: Vector3 = get_point_position(id)

			_connect_with_neighbors(cell)

func _connect_with_neighbors(cell: Vector2) -> void:
	var id: int = _flatten(cell)
	var neighbors: Array = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)
		if rect.has_point(n) and\
				not are_points_connected(id, n_id) and\
				not map.locations[id].is_blocked and\
				not map.locations[n_id].is_blocked:
			connect_points(id, n_id)

func _disconnect_with_neighbors(cell: Vector2) -> void:
	var id: int = _flatten(cell)
	var neighbors = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)
		if rect.has_point(n):
			if are_points_connected(id, n_id):
				disconnect_points(id, n_id)
			elif are_points_connected(n_id, id):
				disconnect_points(n_id, id)

func _flatten(cell: Vector2) -> int:
	return Utils.flatten(cell, int(rect.size.x))
#override the _compute_cost for astar
#since compute cost is always called on adjacent hexes, the value should always be base of 1 (weights get calcualted in by the algorithim)
#by defauly 2 of the 6 neighbors would instead have had sqrt(2), hences the override function
func _compute_cost(from_id: int, to_id: int) -> float:
	return 1.0
#for debug purposes, may remove later
func num_neighbors(cell: Vector2) -> int:
	var id: int = _flatten(cell)
	var neighbors: Array = Hex.get_neighbors(cell)
	var ret: int = 0
	for n in neighbors:
		var n_id: int = _flatten(n)
		if not rect.has_point(n):
			continue
		if are_points_connected(id, n_id):
			ret+=1
	return ret

func get_neighbors(cell: Vector2) -> PoolIntArray:
	var id: int = _flatten(cell)
	var neighbors: Array = Hex.get_neighbors(cell)
	return get_point_connections(id)
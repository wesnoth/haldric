extends Resource
class_name Grid

var rect := Rect2()
var astar := AStar.new()
var map: TileMap = null

func _init(new_map: TileMap, map_rect: Rect2) -> void:
	map = new_map
	rect = map_rect

	_generate_points()
	_generate_point_connections()

func find_path_by_position(start_position: Vector2, end_position: Vector2) -> Array:
	var start_cell := map.world_to_map(start_position)
	var end_cell := map.world_to_map(end_position)

	return find_path_by_cell(start_cell, end_cell)

func find_path_by_cell(start_cell: Vector2, end_cell: Vector2) -> Array:
	var path2D := []
	if rect.has_point(start_cell) and rect.has_point(end_cell):
		var path3D: PoolVector3Array = astar.get_point_path(_flatten(start_cell), _flatten(end_cell))
		for point in path3D:
			path2D.append(Vector2(point.x, point.y))

	return path2D

func make_cell_one_way(cell: Vector2):
	var id: int = _flatten(cell)
	var neighbors = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)

		if rect.has_point(n) and astar.are_points_connected(id, n_id):
			astar.disconnect_points(id, n_id)
			astar.connect_points(n_id,id,false)

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

			astar.add_point(id, Vector3(x, y, 0))

func _generate_point_connections() -> void:
	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)
			var point: Vector3 = astar.get_point_position(id)

			_connect_with_neighbors(cell)

func _connect_with_neighbors(cell: Vector2) -> void:
	var id: int = _flatten(cell)
	var neighbors: Array = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)

		if rect.has_point(n) and\
				not astar.are_points_connected(id, n_id) and\
				not map.locations[id].is_blocked and\
				not map.locations[n_id].is_blocked:
			astar.connect_points(id, n_id)

func _disconnect_with_neighbors(cell: Vector2) -> void:
	var id: int = _flatten(cell)
	var neighbors = Hex.get_neighbors(cell)

	for n in neighbors:
		var n_id: int = _flatten(n)

		if rect.has_point(n):
			if astar.are_points_connected(id, n_id):
				astar.disconnect_points(id, n_id)
			elif astar.are_points_connected(n_id, id):
				astar.disconnect_points(n_id, id)

func _flatten(cell: Vector2) -> int:
	return Utils.flatten(cell, int(rect.size.x))

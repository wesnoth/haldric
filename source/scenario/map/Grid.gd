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

func make_location_one_way(location: Location) -> void:
	for adjacent_location in location.get_adjacent_locations():
		if rect.has_point(adjacent_location.cell) and are_points_connected(location.id, adjacent_location.id):
			disconnect_points(location.id, adjacent_location.id)
			connect_points(adjacent_location.id,adjacent_location.id,false)

func block_location(location: Location) -> void:
	_disconnect_with_neighbors(location)

func unblock_location(location: Location) -> void:
	_disconnect_with_neighbors(location)
	_connect_with_neighbors(location)

func _generate_points() -> void:
	for location in map.locations_dict.values():
		add_point(location.id, Vector3(location.cell.x, location.cell.y, 0))

func _generate_point_connections() -> void:
	for location in map.locations_dict.values():
		_connect_with_neighbors(location)

func _connect_with_neighbors(location: Location) -> void:
	for adjacent_location in location.get_adjacent_locations():
		if rect.has_point(location.cell) and\
			not are_points_connected(location.id, adjacent_location.id) and\
			not location.is_blocked and\
			not adjacent_location.is_blocked:
			connect_points(location.id, adjacent_location.id)

func _disconnect_with_neighbors(location: Location) -> void:
	for adjacent_location in location.get_adjacent_locations():
		if rect.has_point(adjacent_location.cell):
			if are_points_connected(location.id, adjacent_location.id):
				disconnect_points(location.id, adjacent_location.id)
			elif are_points_connected(adjacent_location.id, location.id):
				disconnect_points(adjacent_location.id, location.id)

#override the _compute_cost for astar
#since compute cost is always called on adjacent hexes, the value should always be base of 1 (weights get calcualted in by the algorithim)
#by defauly 2 of the 6 neighbors would instead have had sqrt(2), hences the override function

func _compute_cost(from_id: int, to_id: int) -> float:
	return 1.0
	
#for debug purposes, may remove later
func enum_connected_points(location: Location) -> int:
	var ret: int = 0
	for adjacent_location in location.get_adjacent_locations():
		if not rect.has_point(adjacent_location.cell):
			continue
		if are_points_connected(location.id, adjacent_location.id):
			ret+=1
	return ret

func get_connected_points(location: Location) -> PoolIntArray:
	return get_point_connections(location.id)
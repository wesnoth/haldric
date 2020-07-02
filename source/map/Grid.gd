extends AStar
class_name Grid


var blocked_cells := []


func _init(cells: Array, rect: Rect2) -> void:
	_generate_points(cells, rect)
	_generate_point_connections(cells, rect)


func _estimate_cost(from_id: int, to_id: int) -> float:
	return 1.0


func _compute_cost(from_id: int, to_id: int) -> float:
	return 1.0


func restore(rect: Rect2) -> void:
	for cell in blocked_cells:
		unblock_cell(cell, rect)
	blocked_cells = []


func block_cell(cell: Vector2, rect: Rect2) -> void:
	_disconnect_with_neighbors(cell, rect)
	blocked_cells.append(cell)

func unblock_cell(cell: Vector2, rect: Rect2) -> void:
	_disconnect_with_neighbors(cell, rect)
	_connect_with_neighbors(cell, rect)


func _generate_points(cells: Array, rect: Rect2) -> void:
	for cell in cells:
		add_point(_flatten(cell, rect.size.x), Hex.quad2cube(cell))


func _generate_point_connections(cells: Array, rect: Rect2) -> void:
	for cell in cells:
		_connect_with_neighbors(cell, rect)


func _connect_with_neighbors(cell: Vector2, rect: Rect2) -> void:
	for n_cell in Hex.get_neighbors(cell):
		if rect.has_point(n_cell) and not are_points_connected(_flatten(cell, rect.size.x), _flatten(n_cell, rect.size.x)):
			connect_points(_flatten(cell, rect.size.x), _flatten(n_cell, rect.size.x))


func _disconnect_with_neighbors(cell: Vector2, rect: Rect2) -> void:
	for n_cell in Hex.get_neighbors(cell):
		if rect.has_point(n_cell):
			if are_points_connected(_flatten(cell, rect.size.x), _flatten(n_cell, rect.size.x)):
				disconnect_points(_flatten(cell, rect.size.x), _flatten(n_cell, rect.size.x))
			elif are_points_connected(_flatten(n_cell, rect.size.x), _flatten(cell, rect.size.x)):
				disconnect_points(_flatten(n_cell, rect.size.x), _flatten(cell, rect.size.x))


func _flatten(cell: Vector2, width: int) -> int:
	return int(cell.y) * width + int(cell.x)

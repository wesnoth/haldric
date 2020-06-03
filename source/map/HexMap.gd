extends TileMap
class_name HexMap

signal cell_hovered(cell)

var _hovered_cell := Vector2()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_position := get_global_mouse_position()

		var cell = world_to_map(mouse_position)

		if cell != _hovered_cell:
			_hovered_cell = cell
			emit_signal("cell_hovered", cell)


func map_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world(cell) + _calculate_offset()


func _calculate_cell_size() -> Vector2:
	var length := max(cell_size.x, cell_size.y)
	return Vector2(length, length)


func _calculate_offset() -> Vector2:
	return _calculate_cell_size() / 2

extends Node2D
class_name HexMap

signal cell_hovered(cell)

var _hovered_cell := Vector2()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_position := get_global_mouse_position()

		var cell = Hex.world_to_map(mouse_position)

		if cell != _hovered_cell:
			_hovered_cell = cell
			emit_signal("cell_hovered", cell)


extends ViewportContainer

signal minimap_area_of_view_moved

var dragging = false

func _gui_input(event : InputEvent) -> void:

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		dragging = true

	if event is InputEventMouseMotion and dragging:
		emit_signal("minimap_area_of_view_moved", event.position)

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		dragging = false
		emit_signal("minimap_area_of_view_moved", event.position)

extends ScrollContainer
class_name CardSelector

onready var grid_container := $CenterContainer/GridContainer as GridContainer

func animate() -> void:
	_hide_all_cards()
	for card in grid_container.get_children():
		yield(get_tree().create_timer(0.2), "timeout")
		card.animate()

func _hide_all_cards() -> void:
	for card in grid_container.get_children():
		card.modulate = Color("00FFFFFF")
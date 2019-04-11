extends ScrollContainer
class_name CardSelector

onready var card_container := $CenterContainer/CardContainer as HBoxContainer

func animate() -> void:
	_hide_all_cards()
	for card in card_container.get_children():
		yield(get_tree().create_timer(0.2), "timeout")
		card.animate()

func _hide_all_cards() -> void:
	for card in card_container.get_children():
		card.modulate = Color("00FFFFFF")

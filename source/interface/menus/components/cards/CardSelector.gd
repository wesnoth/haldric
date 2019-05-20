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

func _on_card_pressed(card: MenuCard, id: String) -> void:
	if card.expanded:
		card.shrink()
		_on_shrink(card)
	else:
		card.expand(Rect2(rect_global_position, rect_size))
		_on_expand(card)

func _on_shrink(selected_card: MenuCard) -> void:
	for card in card_container.get_children():
		if card != selected_card:
			card.animate()
			card.show()
			pass

func _on_expand(selected_card: MenuCard) -> void:
	for card in card_container.get_children():
		if card != selected_card:
			card.hide()
			pass

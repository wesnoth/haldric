extends CardSelector
class_name CampaignSelector

const CampaignCard = preload("res://source/interface/menus/components/cards/CampaignCard.tscn")

func _ready() -> void:
	for campaign in Registry.campaigns:
		_add_campaign(campaign)

func _add_campaign(campaign) -> void:
	var file_data : Dictionary = Registry.campaigns[campaign]
	var card := CampaignCard.instance()
	# warning-ignore:return_value_discarded
	card.connect("pressed", self, "_on_campaign_card_pressed", [card, campaign])
	card_container.add_child(card)
	card.initialize(file_data.data)

func _on_campaign_card_pressed(card: MenuCard, id: String) -> void:
	print(id, " selected; loading Campaign")
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

func _on_expand(selected_card: MenuCard) -> void:
	for card in card_container.get_children():
		if card != selected_card:
			card.hide()
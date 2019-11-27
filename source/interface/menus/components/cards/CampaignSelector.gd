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
	._on_card_pressed(card, id)

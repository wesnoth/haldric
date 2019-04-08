extends MenuPage

onready var campaign_selector := $CampaignSelector as CampaignSelector

func _enter() -> void:
	campaign_selector.animate()


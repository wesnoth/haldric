extends MenuPage

onready var campaign_selector = $CampaignSelector

func _enter() -> void:
	campaign_selector.animate()


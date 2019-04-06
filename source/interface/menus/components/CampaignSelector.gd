extends ScrollContainer
class_name CampaignSelector

onready var campaign_cards = $CenterContainer/GridContainer.get_children()

func animate():
	_hide_all_cards()
	for child in campaign_cards:
		child.animate()
		yield(get_tree().create_timer(0.1), "timeout")

func _hide_all_cards() -> void:
	for child in campaign_cards:
		child.modulate = Color("00FFFFFF")
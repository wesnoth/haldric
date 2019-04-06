extends Button
class_name CampaignCard

onready var tween = $Tween as Tween
onready var label = $Label

func initialize(campaign_name):
	label.text = campaign_name

func animate() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
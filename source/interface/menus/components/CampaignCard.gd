extends Button
class_name CampaignCard

# TODO: this is just for testing. These should acutaly be taken from campaign metadata
export var title := ""
export var background: Texture = null

onready var tween = $Tween as Tween
onready var title_label = $Title as Label
onready var background_texture = $Background as TextureRect

func _ready() -> void:
	if title:
		title_label.text = title
	else:
		title_label.text = "Y U NO SET TITLE"

	if background:
		background_texture.texture = background

func initialize(campaign_name):
	title_label.text = campaign_name

func animate() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

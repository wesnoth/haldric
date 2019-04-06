extends Button
class_name MenuCard

onready var tween = $Tween as Tween
onready var title = $Title as Label
onready var card_image = $CardImage as TextureRect

func animate() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func initialize(card : RCard) -> void:
	title.text = card.title
	card_image.texture = card.card_image
	print(card.card_image)
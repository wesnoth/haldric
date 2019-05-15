extends Button
class_name MenuCard

var origin := Rect2()

var expanded := false

onready var tween = $Tween as Tween
onready var title = $Title as Label
onready var card_image = $CardImage as TextureRect

func animate() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func initialize(card : RCard) -> void:
	title.text = card.title
	card_image.texture = card.card_image

func expand(rect: Rect2) -> void:
	expanded = true
	origin = Rect2(rect_global_position, rect_size)
	tween.interpolate_property(self, "rect_size", rect_size, rect.size, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_global_position", rect_global_position, rect.position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func shrink() -> void:
	expanded = false
	tween.interpolate_property(self, "rect_size", rect_size, origin.size, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_global_position", rect_global_position, origin.position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
extends NinePatchRect
class_name ButtonHover

onready var tween := $Tween as Tween

func highlight_button(button: Button, time) -> void:
	tween.interpolate_property(self, "rect_global_position", rect_global_position, button.rect_global_position, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_size", rect_size, button.rect_size, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
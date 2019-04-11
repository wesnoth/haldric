extends Control
class_name ButtonHover

onready var tween := $Tween as Tween

func highlight_button(button: Button, time) -> void:
	modulate = Color("00FFFFFF")
	rect_global_position = button.rect_global_position
	rect_size = button.rect_size

#	#warning-ignore:return_value_discarded
#	tween.interpolate_property(self, "rect_global_position", rect_global_position, button.rect_global_position, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#	#warning-ignore:return_value_discarded
#	tween.interpolate_property(self, "rect_size", rect_size, button.rect_size, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#	#warning-ignore:return_value_discarded
#	tween.start()

	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_size", Vector2(50, rect_size.y), rect_size, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

extends Control
class_name MenuPage

onready var tween := $Tween as Tween

onready var backgrounds := $Background.get_children()

onready var menu_bar_hook := $MenuBarHook as Control

func _ready() -> void:
	visible = false
	modulate = Color("00FFFFFF")

func fade_in(direction: int, time: float) -> void:
	_enter()

	var start_pos = Vector2(get_viewport().size.x * direction, 0)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_position", start_pos, Vector2(0, 0), time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "visible", false, true, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

	for layer in backgrounds:
		layer.fade_in(direction, time)

func fade_out(direction: int, time: float) -> void:
	var start_pos = Vector2(get_viewport().size.x * direction, 0)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_position", Vector2(0, 0), -start_pos, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("FFFFFFFF"), Color("00FFFFFF"), time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "visible", true, false, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

	for layer in backgrounds:
		layer.fade_out(direction, time)

	_leave(time)

func _enter() -> void:
	pass

func _leave(time: float) -> void:
	pass

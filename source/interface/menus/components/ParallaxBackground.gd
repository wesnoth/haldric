extends TextureRect

var origin := Vector2(0, 0)

export var scale := 0.5

onready var tween := $Tween as Tween

func _ready():
	modulate = Color("00FFFFFF")
	origin = rect_position

func fade_in(direction: int, time: float) -> void:
	var start_pos = origin + Vector2(get_viewport().size.x * scale * direction, 0)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_position", start_pos, origin, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

func fade_out(direction: int, time: float) -> void:
	var end_pos = origin - Vector2(get_viewport().size.x * scale * direction, 0)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_position", rect_position, end_pos, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("FFFFFFFF"), Color("00FFFFFF"), time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()
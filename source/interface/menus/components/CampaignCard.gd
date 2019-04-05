extends NinePatchRect

onready var tween = $Tween as Tween

func animate() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	call_deferred("set_visible", true)
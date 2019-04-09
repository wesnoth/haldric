extends Sprite

# :Side
var side = null

onready var anim := $AnimationPlayer

func play(flag_name: String) -> void:
	if anim.has_animation(flag_name):
		anim.play(flag_name)
	else:
		anim.play("flag")
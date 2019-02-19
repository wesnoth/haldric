extends CanvasLayer

var next_scene = null

onready var anim = $AnimationPlayer

func change_scene(scene):
	next_scene = scene
	anim.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		if not get_tree().change_scene(next_scene) == OK:
			print("Global: failed to load ", next_scene)
		anim.play("fade_in")
		next_scene = null
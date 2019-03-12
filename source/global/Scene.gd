extends CanvasLayer

# Scenes
var Game = "res://source/game/Game.tscn"

var next_scene := ""

onready var anim = $AnimationPlayer

func change(scene) -> void:
	next_scene = scene
	anim.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "fade_out":
		if not get_tree().change_scene(next_scene) == OK:
			print("Global: failed to load ", next_scene)
		anim.play("fade_in")
		next_scene = ""
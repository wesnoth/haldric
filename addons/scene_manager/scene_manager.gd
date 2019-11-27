tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("Scene", "res://addons/scene_manager/source/Scene.tscn")

func _exit_tree() -> void:
	remove_autoload_singleton("Scene")

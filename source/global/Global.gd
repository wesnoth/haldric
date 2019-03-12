extends Node

# Resources
var tileset = preload("res://graphics/tilesets/tileset.tres")

# Toggle Fullscreen
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		OS.window_size = Vector2(1280, 720)
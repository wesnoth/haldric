extends Node

# Resources
var tileset = preload("res://graphics/tilesets/tileset.tres")

var fullscreen = false
# Toggle Fullscreen
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
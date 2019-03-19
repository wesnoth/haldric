extends Node

# Resources
var tileset: TileSet = preload("res://graphics/tilesets/tileset.tres")

var version: String = _get_version_string()
var scenario_name := ""

# Toggle Fullscreen
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func _get_version_string() -> String:
	var new_version := ""
	new_version += str(ProjectSettings.get("application/version/major"), ".")
	new_version += str(ProjectSettings.get("application/version/minor"), ".")
	new_version += str(ProjectSettings.get("application/version/patch"), "-")
	new_version += str(ProjectSettings.get("application/version/status"))
	
	return new_version

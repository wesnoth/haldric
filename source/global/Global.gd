extends Node

# References
var Camera = null

var version: Vector3 = _get_version()
var version_string: String = _get_version_string()

var state := {
	scenario = {},
	current_side = null,
}

# Toggle Fullscreen
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func _ready() -> void:
	Scene.register_scene("TitleScreen", "res://source/menu/TitleScreen.tscn")
	Scene.register_scene("Game", "res://source/game/Game.tscn")
	Scene.register_scene("Editor", "res://source/editor/Editor.tscn")
	Scene.register_scene("Scenarios", "res://source/menu/Scenarios.tscn")

func _get_version() -> Vector3:
	return Vector3(
		ProjectSettings.get("application/version/major"),
		ProjectSettings.get("application/version/minor"),
		ProjectSettings.get("application/version/patch")
	)

func _get_version_string() -> String:
	return "%d.%d.%d-%s" % [
		version.x,
		version.y,
		version.z,
		ProjectSettings.get("application/version/status")
	]

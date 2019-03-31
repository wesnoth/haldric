extends Node

# References
var Camera = null

var version: Vector3 = _get_version()
var version_string: String = _get_version_string()

var scenario_name := ""

# Toggle Fullscreen
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func _get_version() -> Vector3:
	return Vector3(
		ProjectSettings.get("application/version/major"),
		ProjectSettings.get("application/version/minor"),
		ProjectSettings.get("application/version/patch")
	)

func _get_version_string() -> String:
	var new_version := ""
	new_version += str(version.x, ".")
	new_version += str(version.y, ".")
	new_version += str(version.z, "-")
	new_version += str(ProjectSettings.get("application/version/status"))

	return new_version

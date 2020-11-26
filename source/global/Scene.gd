extends Node


var scenes := {
	"TitleScreen": "res://source/menu/TitleScreen.tscn",
	"Game": "res://source/game/Game.tscn",
	"MapEditor": "res://source/editor/MapEditor.tscn",
	"ScenarioSelectionMenu": "res://source/menu/ScenarioSelectionMenu.tscn",
}

func change(scene_name: String) -> void:
	if not scenes.has(scene_name):
		print("cannot change to scene %s" % scene_name)
		return

	get_tree().change_scene(scenes[scene_name])

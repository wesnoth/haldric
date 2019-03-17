extends Control

func _ready():
	Audio.play(Registry.music.return_to_wesnoth)
	$Version.text = Global.version

func _on_Singleplayer_pressed() -> void:
	Scene.change(Scene.Game)

func _on_Options_pressed() -> void:
	Scene.change(Scene.Options)

func _on_Quit_pressed() -> void:
	get_tree().quit()


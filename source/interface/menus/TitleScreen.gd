extends Control

onready var anim = $AnimationPlayer

func _ready() -> void:
	Audio.play(Registry.music.return_to_wesnoth)
	$Version.text = Global.version_string

func _on_Singleplayer_pressed() -> void:
	Scene.change(Scene.ChooseScenario)

func _on_Campaigns_pressed():
	anim.play("campaigns_enter")

func _on_ChooseCampaign_back():
	anim.play("campaigns_back")

func _on_Lobby_pressed():
	Scene.change(Scene.Lobby)

func _on_Editor_pressed() -> void:
	Scene.change(Scene.Editor)

func _on_Options_pressed() -> void:
	Scene.change(Scene.Options)

func _on_Quit_pressed() -> void:
	get_tree().quit()

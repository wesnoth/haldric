extends Menu

onready var version = $Version

func _ready() -> void:
	Audio.play(Registry.music.return_to_wesnoth)
	version.text = Global.version_string

	for button in $HUD/MenuBar/HBoxContainer/Buttons.get_children():
		menu_bar.register_button(button)

	call_deferred("_set_current_page", pages[0])
	menu_bar.reveal()

func _on_Quit_pressed():
	get_tree().quit()
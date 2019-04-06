extends Menu

onready var version = $Version
onready var press_enter = $PressEnter

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not ready:
		_set_current_page(pages[0])
		menu_bar.reveal()
		press_enter.hide()
		ready = true

func _ready() -> void:
	Audio.play(Registry.music.return_to_wesnoth)
	version.text = Global.version_string

	for button in $HUD/MenuBar/HBoxContainer/Buttons.get_children():
		menu_bar.register_button(button)

func _on_Quit_pressed():
	get_tree().quit()
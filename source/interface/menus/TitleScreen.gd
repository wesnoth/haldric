extends Menu

onready var menu_bar = $VMenuBar

onready var version = $Version

func _ready() -> void:
	#Audio.play(Registry.music.return_to_wesnoth)
	version.text = Global.version_string

func _on_Tutorials_pressed() -> void:
	open_page("Tutorials")

func _on_Campaigns_pressed() -> void:
	open_page("Campaigns")

func _on_Scenarios_pressed() -> void:
	open_page("Scenarios")

func _on_Addons_pressed() -> void:
	open_page("Addons")

func _on_Settings_pressed() -> void:
	open_page("Settings")

func _on_Credits_pressed() -> void:
	open_page("Credits")

func _on_Editor_pressed() -> void:
	Scene.change(Scene.Editor)

func _on_Quit_pressed() -> void:
	get_tree().quit()





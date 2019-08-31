extends Menu

onready var menu_bar := $VMenuBar as Control

onready var version := $Version as Label
onready var header := $Header as Label

func _ready() -> void:
	# Audio.play_music(load(Registry.music.return_to_wesnoth))
	version.text = Global.version_string

	#warning-ignore:return_value_discarded
	connect("page_changed", self, "_on_page_changed")

func _on_Home_pressed() -> void:
	open_page("Home")

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

func _on_page_changed(new_page: MenuPage) -> void:
	header.text = "" if new_page.name == "Home" else new_page.name

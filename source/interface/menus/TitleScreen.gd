extends Menu

onready var menu_bar := $VMenuBar
onready var menu_bar_pos_original: Vector2 = menu_bar.rect_position

onready var version := $Version
onready var header := $Header

func _ready() -> void:
	#Audio.play(Registry.music.return_to_wesnoth)
	version.text = Global.version_string

	#warning-ignore:return_value_discarded
	connect("page_changed", self, "on_page_changed")

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

func on_page_changed(new_page: MenuPage) -> void:
	var new_pos: Vector2 = menu_bar.rect_position

	# TODO: better method than checking by name
	if new_page.name == "Home":
		new_pos.x = menu_bar_pos_original.x
		header.text = ""
	else:
		new_pos.x = 100
		header.text = new_page.name

	if menu_bar.rect_position == new_pos:
		return

	tween.interpolate_property(menu_bar, "rect_position", menu_bar.rect_position, new_pos, page_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

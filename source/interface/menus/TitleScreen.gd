extends Menu

onready var menu_bar := $VMenuBar
onready var menu_bar_pos_original: Vector2 = menu_bar.rect_position

onready var version := $Version

func _ready() -> void:
	#Audio.play(Registry.music.return_to_wesnoth)
	version.text = Global.version_string

	#warning-ignore:return_value_discarded
	connect("page_changed", self, "on_page_changed")

func _on_Main_pressed() -> void:
	open_page("Main")

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

	if new_page.name == "Main":
		new_pos.x = menu_bar_pos_original.x
	else:
		new_pos.x = 100

	if menu_bar.rect_position == new_pos:
		return

	# TODO: make time match the paging time
	tween.interpolate_property(menu_bar, "rect_position", menu_bar.rect_position, new_pos, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

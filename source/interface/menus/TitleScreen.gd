extends Menu

onready var menu_bar := $VMenuBar as Control

onready var version := $Version as Label
onready var header := $Header as Label

func _ready() -> void:
	# Audio.play(load(Registry.music.return_to_wesnoth))
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
	var new_position = new_page.menu_bar_hook.rect_position
	var new_size = new_page.menu_bar_hook.rect_size

	header.text = "" if new_page.name == "Home" else new_page.name

	if menu_bar.rect_position == new_position:
		return

	menu_bar.anchor_bottom = new_page.menu_bar_hook.anchor_bottom
	menu_bar.anchor_top = new_page.menu_bar_hook.anchor_top
	menu_bar.anchor_left = new_page.menu_bar_hook.anchor_left
	menu_bar.anchor_right = new_page.menu_bar_hook.anchor_right

	tween.interpolate_property(menu_bar, "rect_position", menu_bar.rect_position, new_position, page_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(menu_bar, "rect_size", menu_bar.rect_size, new_size, page_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(header, "self_modulate", Color("00FFFFFF"), Color("FFFFFFFF"), page_time, Tween.TRANS_SINE, Tween.EASE_IN)

	tween.start()

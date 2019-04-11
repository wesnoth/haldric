extends Control
class_name Menu

var direction: int = 0

export var page_time := 0.6

onready var anim = $AnimationPlayer
onready var tween := $Tween
onready var camera := $Camera2D as Camera2D

onready var menu_bar := $HUD/MenuBar as MenuBar
onready var menu_bar_vertical := $HUD/MenuBarVertical as MenuBarVertical

onready var pages := $Pages.get_children()
onready var buttons := $HUD/MenuBar/HBoxContainer/Buttons.get_children()

onready var current_page : MenuPage = null

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_right") and not tween.is_active():
		_next_page()
	elif event.is_action_pressed("ui_left") and not tween.is_active():
		_previous_page()

func _ready() -> void:
	menu_bar.modulate = Color("00FFFFFF")
	#warning-ignore:return_value_discarded

func _next_page() -> void:
	var next_index = (current_page.get_index() + 1) % pages.size()
	_on_MenuBar_button_pressed(next_index)

func _previous_page() -> void:
	var previous_index = current_page.get_index() - 1
	if previous_index < 0:
		previous_index = pages.size() - 1
	_on_MenuBar_button_pressed(previous_index)

func _animate(menu_page: MenuPage) -> void:
	menu_page.fade_in(direction, page_time)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(camera, "position", camera.position, menu_page.rect_position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

func _set_current_page(value):
	var index = value.get_index()

	if current_page:
		direction = index - current_page.get_index()
		current_page.fade_out(direction, page_time)

	current_page = value

	_animate(current_page)
	menu_bar.highlight_button(current_page.get_index())

func _on_MenuBar_button_pressed(id):
	_set_current_page(pages[id])
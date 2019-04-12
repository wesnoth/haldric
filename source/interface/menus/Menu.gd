extends Control
class_name Menu

signal page_changed(new_page)

var direction: int = 0

export var page_time := 0.6

onready var tween := $Tween

onready var pages := $Pages

onready var current_page : MenuPage = null

func _ready() -> void:
	if pages.get_child_count() > 0:
		current_page = pages.get_child(0)
		current_page.fade_in(direction, page_time)

func open_page(page_name) -> void:
	var page = pages.get_node(page_name)
	if page:
		to_page(page.get_index())

func to_page(index: int):

	if pages.get_child_count() == 0:
		return

	if current_page:
		direction = index - current_page.get_index()
		current_page.fade_out(direction, page_time)

	current_page = pages.get_child(index)
	current_page.fade_in(direction, page_time)

	emit_signal("page_changed", current_page)

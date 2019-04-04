extends Control

signal back

onready var grid_container = $ScrollContainer/CenterContainer/GridContainer as GridContainer

onready var campaign_cards = grid_container.get_children()

func _ready() -> void:
	hide_all_cards()

func animate() -> void:
	hide_all_cards()
	for child in campaign_cards:
		child.animate()
		yield(get_tree().create_timer(0.1), "timeout")

func hide_all_cards() -> void:
	for child in campaign_cards:
		child.modulate = Color("00FFFFFF")

func _on_Back_pressed() -> void:
	emit_signal("back")
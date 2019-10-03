extends Control
class_name SidePanelItem

export var texture: Texture = null

onready var label := $HBoxContainer/Label as Label
onready var extra_label := $HBoxContainer/ExtraLabel as Label
onready var texture_rect := $HBoxContainer/TextureRect as TextureRect

func _ready() -> void:
	texture_rect.texture = texture

func set_text(text: String) -> void:
	label.text = text

func set_extra_text(text: String) -> void:
	extra_label.text = text
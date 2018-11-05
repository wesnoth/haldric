extends Control

export(Texture) var tex

onready var icon = $"Info/Icon"
onready var label = $"Info/Label"

func _ready():
	icon.texture = tex

func set_text(text):
	label.text = text

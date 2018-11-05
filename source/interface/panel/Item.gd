extends Control

export(Texture) var tex

onready var icon = $"HBox/Icon"
onready var label = $"HBox/Label"

func _ready():
	icon.texture = tex

func set_text(text):
	label.text = text

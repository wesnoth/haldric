extends Control

export(String) var text = "HP"
export(Color) var color = Color("ffffffff")

onready var label = $"Label"

func _ready():
	label.text = str(text)
	label.self_modulate = color

func set_text(text):
	label.text = str(text)

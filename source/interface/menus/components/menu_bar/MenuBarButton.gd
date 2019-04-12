extends Button

export var show_background := true

onready var background = $Background as TextureRect

func _ready() -> void:
	background.visible = show_background
	text = name

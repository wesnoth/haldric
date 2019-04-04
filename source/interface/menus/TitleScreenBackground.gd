extends Node

onready var background = $ParallaxBackground/ParallaxLayer/Background as TextureRect
onready var parallax_layer = $ParallaxBackground/ParallaxLayer as ParallaxLayer

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()

func _on_screen_resized() -> void:
	var size : Vector2 = get_viewport().size
	background.rect_size = size
	parallax_layer.motion_mirroring.x = size.x
extends ParallaxBackground

onready var texture_rect = $ParallaxLayer/TextureRect as TextureRect
onready var parallax_layer := $ParallaxLayer as ParallaxLayer

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	_on_screen_resized()

func _on_screen_resized():
	texture_rect.rect_size = get_viewport().size
	parallax_layer.motion_mirroring = get_viewport().size
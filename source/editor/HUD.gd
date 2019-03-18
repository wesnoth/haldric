extends CanvasLayer

onready var container = $TileButtons/GridContainer

func add_button(button : TextureButton) -> void:
	container.add_child(button)

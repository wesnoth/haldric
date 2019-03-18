extends CanvasLayer

onready var container = $TileButtons/VBoxContainer

func add_button(button : TextureButton) -> void:
	container.add_child(button)

extends CanvasLayer

onready var container := $TileButtons/GridContainer as GridContainer
onready var pause_menu := $PauseMenu

func add_button(button: TextureButton) -> void:
	container.add_child(button)

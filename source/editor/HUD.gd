extends CanvasLayer

onready var container := $TileButtons/GridContainer as GridContainer
onready var pause_menu := $PauseMenu

func add_button(button: TextureButton) -> void:
	container.add_child(button)

func is_pause_active() -> bool:
	return pause_menu.is_active()
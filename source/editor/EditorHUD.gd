extends CanvasLayer
class_name EditorHUD

onready var container := $TileButtons/GridContainer as GridContainer
onready var pause_menu := $PauseMenu

onready var new_map_button := $UIButtons/HBoxContainer/NewMapButton as Button
onready var save_button := $UIButtons/HBoxContainer/SaveButton as Button
onready var load_button := $UIButtons/HBoxContainer/LoadMapButton as Button
onready var _map_name_line_edit := $UIButtons/HBoxContainer/MapNameLineEdit as LineEdit


func add_button(button: TextureButton) -> void:
	container.add_child(button)

func get_map_name() -> String:
	return _map_name_line_edit.text

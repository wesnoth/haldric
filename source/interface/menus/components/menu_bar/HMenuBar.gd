extends MenuBar
class_name HMenuBar

func _ready() -> void:
	buttons = $HBoxContainer/Buttons.get_children()
	_register_buttons()
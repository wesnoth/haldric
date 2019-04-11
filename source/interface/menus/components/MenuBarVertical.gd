extends Control
class_name MenuBarVertical

signal button_pressed(id)

var buttons := {}

var current_id := 0

onready var hover := $ButtonHover as ColorRect
onready var tween := $Tween as Tween

func reveal() -> void:
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func highlight_button(button_id: int) -> void:
	var button: Button = buttons[button_id]
	var time := 0.4

	#warning-ignore:return_value_discarded
	tween.interpolate_property(hover, "rect_global_position", hover.rect_global_position, button.rect_global_position, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.interpolate_property(hover, "rect_size", hover.rect_size, button.rect_size, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#warning-ignore:return_value_discarded
	tween.start()

func register_button(button: Button) -> void:
	buttons[button.get_index()] = button
	button.connect("pressed", self, "_on_button_pressed", [button.get_index()])

func _on_button_pressed(id: int) -> void:
	highlight_button(id)
	emit_signal("button_pressed", id)

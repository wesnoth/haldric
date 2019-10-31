extends Control
class_name MenuBar

signal button_focused(id)

var _button_register := {}

var buttons := []
var current_button := 0

var origin
var off_screen_position = Vector2(-rect_size.x, rect_position.y)

onready var tween := $Tween as Tween
onready var selected_button_hover := $SelectedButtonHover as ButtonHover

func _ready() -> void:

	# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	call_deferred("highligh_selected_button", 0)
	reveal()

func reveal() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "modulate", Color("00FFFFFF"), Color("FFFFFFFF"), 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func slide_out() -> void:
	origin = rect_global_position
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_global_position:x", rect_global_position.x, off_screen_position.x, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func slide_in() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "rect_global_position:x", rect_global_position.x, origin.x, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	tween.start()

func _button_selected(button_id):

	if not _button_register.has(button_id):
		return

	_button_register[button_id].emit_signal("pressed")

func highligh_selected_button(button_id: int) -> void:

	if not _button_register.has(button_id):
		return

	selected_button_hover.highlight_button(_button_register[button_id], 0.4)

func register_button(button: Button) -> void:
	_button_register[button.get_index()] = button
	# warning-ignore:return_value_discarded
	button.connect("pressed", self, "_on_button_pressed", [button.get_index()])

func next_button():

	if not buttons:
		return

	var next_index = (current_button + 1) % buttons.size()
	to_button(next_index)

func previous_button():

	if not buttons:
		return

	var prev_index = current_button - 1

	if prev_index < 0:
		prev_index = buttons.size() - 1

	to_button(prev_index)

func to_button(new_index):

	if not buttons:
		return

	current_button = new_index
	highligh_selected_button(current_button)
	emit_signal("button_focused", current_button)

func _register_buttons() -> void:
	for button in buttons:
		register_button(button)

func _on_button_pressed(id: int) -> void:
	highligh_selected_button(id)
	emit_signal("button_focused", id)

func _on_screen_resized():
	highligh_selected_button(current_button)

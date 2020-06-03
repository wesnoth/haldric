extends Control
class_name ActionButton

signal pressed()

var disabled := false setget _set_disabled
var text := "" setget _set_text
var tooltip := "" setget _set_tooltip

onready var button := $Button as Button

static func instance() -> ActionButton:
	return load("res://source/interface/action/ActionButton.tscn").instance() as ActionButton


func _set_disabled(value: bool) -> void:
	disabled = value
	button.disabled = value


func _set_text(value: String) -> void:
	text = value
	button.text = value


func _set_tooltip(value: String) -> void:
	tooltip = value
	button.hint_tooltip = value


func _on_Button_pressed() -> void:
	emit_signal("pressed")

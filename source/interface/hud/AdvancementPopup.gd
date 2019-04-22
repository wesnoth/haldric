extends Popup
class_name AdvancementPopup

signal advancement_selected(unit, advance_id)

const AdvancementButton = preload("res://source/interface/hud/components/AdvancementButton.tscn")

var unit : Unit = null

onready var advancement_buttons := $MarginContainer/AdvancementButtons as VBoxContainer

func popup_unit(unit: Unit) -> void:
	_clear()

	self.unit = unit

	var advancements = unit.type.advances_to

	if not advancements:
		return

	for unit_id in advancements:
		var button = AdvancementButton.instance()
		button.connect("pressed", self, "_on_button_pressed", [unit_id])
		button.text = unit_id
		advancement_buttons.add_child(button)

	popup_centered()

func _clear():
	for button in advancement_buttons.get_children():
		advancement_buttons.remove_child(button)

func _on_button_pressed(unit_id):
	emit_signal("advancement_selected", unit, unit_id)
	unit = null
	hide()
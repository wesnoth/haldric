extends Control
class_name RecallDialogue

signal option_selected(unit_type_id)
signal cancelled()

var GROUP := ButtonGroup.new()

onready var recall_button := $Panel/VBoxContainer/Buttons/Recall as Button
onready var options := $Panel/VBoxContainer/HBoxContainer/Options

onready var recall_info := $Panel/VBoxContainer/HBoxContainer/UnitRecallInfo


func update_info(side: Side) -> void:
	clear()
	for data in side.recall:
		var unit_type_id = data["id"]
		if not Data.units.has(unit_type_id):
			print("unit type %s in recalls of side %d does not exist!" % [unit_type_id, side.number + 1])
			continue

		var unit_type : UnitType = Data.units[unit_type_id].instance()
		_add_option(side, unit_type, data)

	var has_option := false

	for option in options.get_children():
		if option.disabled:
			continue

		option.pressed = true
		option.emit_signal("pressed")
		has_option = true
		break

	if not has_option:
		recall_button.disabled = true


func _add_option(side: Side, unit_type: UnitType, data: Dictionary) -> void:
	var option := RecallOption.instance()
	option.group = GROUP
	options.add_child(option)
	option.add_child(unit_type)
	unit_type.sprite.hide()
	option.connect("pressed", self, "_on_option_selected", [ unit_type, data ])
	option.update_info(side, unit_type, data)


func clear() -> void:
	recall_button.disabled = false
	recall_info.clear()

	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()


func _on_option_selected(unit_type: UnitType, data: Dictionary) -> void:
	recall_info.update_info(unit_type, data)

	if recall_button.is_connected("pressed", self, "_on_Recall_pressed"):
		recall_button.disconnect("pressed", self, "_on_Recall_pressed")
	recall_button.connect("pressed", self, "_on_Recall_pressed", [unit_type.name, data] )


func _on_Recall_pressed(unit_type_id: String, data: Dictionary) -> void:
	emit_signal("option_selected", unit_type_id, data)


func _on_Cancel_pressed() -> void:
	emit_signal("cancelled")

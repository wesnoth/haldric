extends Control
class_name AdvancementDialogue

var GROUP := ButtonGroup.new()

onready var advance_button := $Panel/VBoxContainer/Buttons/Advance as Button
onready var options := $Panel/VBoxContainer/HBoxContainer/Options

onready var unit_info := $Panel/VBoxContainer/HBoxContainer/UnitRecruitInfo


func update_info(unit: Unit) -> void:
	clear()

	for unit_type_id in unit.type.advances_to:
		if not Data.units.has(unit_type_id):
			print("unit type %s in units advancement options does not exist!" % [unit_type_id])
			continue

		var unit_type : UnitType = Data.units[unit_type_id].instance()

		_add_option(unit, unit_type)

	var has_option := false

	for option in options.get_children():
		if option.disabled:
			continue

		option.pressed = true
		option.emit_signal("pressed")
		has_option = true
		break

	if not has_option:
		advance_button.disabled = true


func _add_option(unit: Unit, unit_type: UnitType) -> void:
	var option := AdvancemenOption.instance()
	option.group = GROUP
	options.add_child(option)
	option.add_child(unit_type)
	unit_type.sprite.hide()
	option.connect("pressed", self, "_on_option_selected", [ unit, unit_type ])
	option.update_info(unit_type)


func clear() -> void:
	advance_button.disabled = false
	unit_info.clear()

	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()


func _on_option_selected(unit: Unit, unit_type: UnitType) -> void:
	unit_info.update_info(unit_type)

	if advance_button.is_connected("pressed", self, "_on_Advance_pressed"):
		advance_button.disconnect("pressed", self, "_on_Advance_pressed")
	advance_button.connect("pressed", self, "_on_Advance_pressed", [unit, unit_type.name ] )


func _on_Advance_pressed(unit: Unit, unit_type_id: String) -> void:
	unit.advance(Data.units[unit_type_id].instance())
	hide()
	clear()


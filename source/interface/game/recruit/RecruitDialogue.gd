extends Control
class_name RecruitDialogue

signal option_selected(unit_type_id)
signal cancelled()

var GROUP := ButtonGroup.new()

onready var recruit_button := $Panel/VBoxContainer/Buttons/Recruit as Button
onready var options := $Panel/VBoxContainer/HBoxContainer/Options

onready var recruit_info := $Panel/VBoxContainer/HBoxContainer/UnitRecruitInfo


func update_info(side: Side) -> void:
	clear()

	for unit_type_id in side.recruit:
		if not Data.units.has(unit_type_id):
			print("unit type %s in recruits of side %d does not exist!" % [unit_type_id, side.number + 1])
			continue

		var unit_type : UnitType = Data.units[unit_type_id].instance()
		_add_option(side, unit_type)

	var has_option := false

	for option in options.get_children():
		if option.disabled:
			continue

		option.pressed = true
		option.emit_signal("pressed")
		has_option = true
		break

	if not has_option:
		recruit_button.disabled = true


func _add_option(side: Side, unit_type: UnitType) -> void:
	var option := RecruitOption.instance()
	option.group = GROUP
	options.add_child(option)
	option.add_child(unit_type)
	unit_type.sprite.hide()
	option.connect("pressed", self, "_on_option_selected", [ unit_type ])
	option.update_info(side, unit_type)


func clear() -> void:
	recruit_button.disabled = false
	recruit_info.clear()

	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()


func _on_option_selected(unit_type: UnitType) -> void:
	recruit_info.update_info(unit_type)

	if recruit_button.is_connected("pressed", self, "_on_Recruit_pressed"):
		recruit_button.disconnect("pressed", self, "_on_Recruit_pressed")
	recruit_button.connect("pressed", self, "_on_Recruit_pressed", [unit_type.name] )


func _on_Recruit_pressed(unit_type_id: String) -> void:
	emit_signal("option_selected", unit_type_id)


func _on_Cancel_pressed() -> void:
	emit_signal("cancelled")

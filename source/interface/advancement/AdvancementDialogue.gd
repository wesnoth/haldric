extends Control
class_name AdvancementDialogue

var GROUP := ButtonGroup.new()

onready var advance_button := $Panel/VBoxContainer/Buttons/Advance as Button
onready var options := $Panel/VBoxContainer/HBoxContainer/Options

onready var unit_info := $Panel/VBoxContainer/HBoxContainer/UnitInfo as UnitAdvancementInfo


func update_info(unit: Unit) -> void:
	clear()

	for advancement in unit.get_advancements():
		_add_option(unit, advancement)

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


func _add_option(unit: Unit, advancement: Advancement) -> void:
	var option := AdvancemenOption.instance()
	option.group = GROUP
	options.add_child(option)
	option.connect("pressed", self, "_on_option_selected", [ unit, advancement ])
	option.update_info(advancement)


func clear() -> void:
	advance_button.disabled = false
	unit_info.clear()

	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()


func _on_option_selected(unit: Unit, advancement: Advancement) -> void:
	unit_info.update_info(unit.duplicate(), advancement)

	if advance_button.is_connected("pressed", self, "_on_Advance_pressed"):
		advance_button.disconnect("pressed", self, "_on_Advance_pressed")
	advance_button.connect("pressed", self, "_on_Advance_pressed", [unit, advancement ] )


func _on_Advance_pressed(unit: Unit, advancement: Advancement) -> void:
	advancement.execute(unit)
	hide()
	clear()


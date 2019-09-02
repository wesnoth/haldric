extends Popup
class_name AttackPopup

signal attack_selected(attack, target)

const AttackButton = preload("res://source/interface/hud/components/AttackButton.tscn")

onready var attack_buttons := $MarginContainer/AttackButtons as VBoxContainer
var target_unit: Unit = null

func popup_attack(unit: Unit, target: Unit) -> void:
	_clear()
	var attacks = unit.type.get_attacks()
	target_unit = target

	if not attacks:
		return

	for attack in attacks:
		var button = AttackButton.instance()
		attack_buttons.add_child(button)
		button.connect("attack_button_pressed", self, "_on_button_pressed")
		button.update_attack(attack)

	popup_centered()

func _clear() -> void:
	for button in attack_buttons.get_children():
		attack_buttons.remove_child(button)

func _on_button_pressed(attack: Attack) -> void:
	emit_signal("attack_selected", attack, target_unit)
	hide()

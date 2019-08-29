extends Popup
class_name AttackPopup

signal attack_selected(attack)

const AttackButton = preload("res://source/interface/hud/components/AttackButton.tscn")

onready var attack_buttons := $MarginContainer/AttackButtons as VBoxContainer

func popup_attack(unit: Unit) -> void:
	_clear()
	var attacks = unit.type.get_attacks()

	if not attacks:
		return

	for attack in attacks:
		var button = AttackButton.instance()
		button.connect("attack_button_pressed", self, "_on_button_pressed")
		attack_buttons.add_child(button)

	popup_centered()

func _clear() -> void:
	for button in attack_buttons.get_children():
		attack_buttons.remove_child(button)

func _on_button_pressed(attack: Attack) -> void:
	emit_signal("attack_selected", attack)
	hide()

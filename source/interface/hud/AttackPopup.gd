extends Popup
class_name AttackPopup

signal attack_selected(attack, target)

const AttackButton = preload("res://source/interface/hud/components/AttackButton.tscn")

onready var attack_buttons := $AttackButtons as VBoxContainer
var target_unit: Unit = null

func popup_attack(unit: Unit, target: Unit) -> void:
	"""
	Creates the list of possible attack buttons for the player to choose from
	"""
	get_tree().call_group("UnitPathDisplay", "hide")
	_clear()

	var attacks = unit.type.get_attacks()
	target_unit = target

	if not attacks:
		return

	for attack in attacks:
		var button = AttackButton.instance()
		attack_buttons.add_child(button)
		button.connect("attack_button_pressed", self, "_on_button_pressed")
		button.update_options(attack, _find_matching_defense(target, attack))

	popup_centered()

func _find_matching_defense(target: Unit, attack: Attack) -> Attack:
	"""
	Finds the best attack the defending unit can use against the current attack
	"""
	var defense = Attack.new() # We will return an empty attack if no matching attack is found
	for possible_defense in target.type.get_attacks():
		if(possible_defense.reach == attack.reach):
			defense = possible_defense
			break # To do more check later to find the optimal defense
	return defense

func _clear() -> void:
	for button in attack_buttons.get_children():
		attack_buttons.remove_child(button)
		button.queue_free()

func _on_button_pressed(combatChoices: Dictionary) -> void:
	get_tree().call_group("UnitPathDisplay", "show")
	emit_signal("attack_selected", combatChoices, target_unit)
	hide()

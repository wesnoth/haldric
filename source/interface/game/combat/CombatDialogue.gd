extends Control
class_name CombatDialogue

signal option_selected(attacker_attack, defender_attack, target)
signal cancelled()

var GROUP := ButtonGroup.new()

var attacker_attack : Attack = null
var defender_attack : Attack = null

var defender : Location = null

onready var attacker_info := $Panel/VBoxContainer/HBoxContainer/Attacker as CombatUnitInfo
onready var defender_info := $Panel/VBoxContainer/HBoxContainer/Defender as CombatUnitInfo

onready var options := $Panel/VBoxContainer/Options


func update_info(time: CustomTime, attacker: Location, _defender: Location) -> void:
	clear()

	defender = _defender
	attacker_info.update_info(attacker)
	defender_info.update_info(defender)

	for attack in attacker.unit.get_attacks():
		var defender_attack = defender.unit.get_counter_attack(attack)
		_add_option(time, attacker, attack, defender, defender_attack)

	var option : CombatOption = options.get_child(0)

	option.pressed = true
	option.emit_signal("pressed")


func clear() -> void:
	attacker_attack = null
	defender_attack = null
	defender = null

	attacker_info.clear()
	defender_info.clear()

	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()


func _add_option(time: CustomTime, attacker: Location, _attacker_attack: Attack, defender: Location, _defender_attack: Attack) -> void:
	var option = CombatOption.instance()
	option.group = GROUP
	option.connect("pressed", self, "_on_option_selected", [ attacker, _attacker_attack, defender, _defender_attack ])
	options.add_child(option)

	var attacker_context = CombatContext.new(attacker, _attacker_attack, time)
	var defender_context = CombatContext.new(defender, _defender_attack, time)

	attacker_context.accuracy = 100 - defender.unit.get_defense(defender.terrain.type)
	defender_context.accuracy = 100 - attacker.unit.get_defense(attacker.terrain.type)

	option.update_info(attacker_context, defender_context)


func _on_option_selected(attacker: Location, _attacker_attack: Attack, defender: Location, _defender_attack: Attack) -> void:
	attacker_attack = _attacker_attack
	defender_attack = _defender_attack

	if _attacker_attack:
		defender_info.update_resistance(defender.unit.get_resistance(_attacker_attack.damage_type))

	if _defender_attack:
		attacker_info.update_resistance(attacker.unit.get_resistance(_defender_attack.damage_type))

func _on_Attack_pressed() -> void:
	emit_signal("option_selected", attacker_attack, defender_attack, defender)


func _on_Cancel_pressed() -> void:
	emit_signal("cancelled")

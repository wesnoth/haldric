extends Button
class_name CombatOption

onready var attacker_info := $MarginContainer/HBoxContainer/Attacker as CombatAttackInfo
onready var defender_info := $MarginContainer/HBoxContainer/Defender as CombatAttackInfo

onready var attack_category_label := $MarginContainer/HBoxContainer/AttackCategory


static func instance() -> CombatOption:
	return load("source/interface/game/combat/CombatOption.tscn").instance() as CombatOption


func update_info(attacker: CombatContext, defender: CombatContext) -> void:
	attacker.apply_specials(attacker, defender, attacker, defender)
	defender.apply_specials(defender, attacker, attacker, defender)

	attacker_info.update_info(attacker, defender)
	defender_info.update_info(defender, attacker)

	attack_category_label.text = "-- %s --" % attacker.category

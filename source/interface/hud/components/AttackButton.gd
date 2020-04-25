extends Button

onready var combatPlate := $CombatPlate #as AttackPlate
var combatChoices = {} # A dictionary which holds the attack/defense pair for this combat

signal attack_button_pressed(attack)

func _ready():
	pass

func update_options(unit: Unit, target: Unit, offense : Attack, defense: Attack) -> void:
	combatPlate.update_attack_label(target, offense, 'offense')
	combatPlate.update_attack_label(unit, defense, 'defense')
	combatPlate.update_attack_type(offense)
	combatChoices['offense'] = offense
	combatChoices['defense'] = defense

func clear() -> void:
	combatPlate.clear()
	combatChoices.clear()

func _on_Button_pressed():
	emit_signal("attack_button_pressed", combatChoices)

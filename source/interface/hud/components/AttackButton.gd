extends Control

onready var attackPlate := $AttackDefense/AttackPlate #as AttackPlate
onready var defensePlate := $AttackDefense/DefensePlate
var combatChoices = {} # A dictionary which holds the attack/defense pair for this combat

signal attack_button_pressed(attack)

func _ready():
	pass

func update_options(attack : Attack, defense: Attack) -> void:
	attackPlate.update_attack_label(attack)
	defensePlate.update_attack_label(defense)
	update_attack_type(attack)
	combatChoices['attack'] = attack
	combatChoices['defense'] = defense

func update_attack_type(attack: Attack):
	$AttackDefense/AttackType.text = "--" + attack.reach + "--"
	
func clear() -> void:
	attackPlate.clear()
	combatChoices.clear()

func _on_Button_pressed():
	emit_signal("attack_button_pressed", combatChoices)

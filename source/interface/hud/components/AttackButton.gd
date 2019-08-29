extends Control

onready var attackPlate := $AttackPlate
var attack_value: Attack = null

signal attack_button_pressed(attack)

func _ready():
	pass

func update_attack(attack : Attack) -> void:
	attackPlate.update_attack(attack)
	attack_value = attack
	pass

func clear() -> void:
	attackPlate.clear()
	attack_value = null
	pass

func _on_Button_pressed():
	emit_signal("attack_button_pressed", attack_value)
	pass

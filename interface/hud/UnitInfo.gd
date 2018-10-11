extends Panel

onready var health = $"HealthLabel"
onready var moves = $"MovesLabel"
onready var attack = $"AttackLabel"

func update_unit_info(unit):
	health.text = str("Health: ", unit.current_health, " / ", unit.base_max_health)
	moves.text = str("Moves: ", unit.current_moves, " / ", unit.base_max_moves)
	attack.text = unit.get_attack_string()

func clear_unit_info():
	health.text = str("Health: -")
	moves.text = str("Moves: -")
	attack.text = str("Attack: -")
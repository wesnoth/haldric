extends Panel

onready var health = $"VBox/HealthLabel"
onready var experience = $"VBox/ExperienceLabel"
onready var moves = $"VBox/MovesLabel"
onready var attack = $"VBox/AttackLabel"

func update_unit_info(unit):
	health.text = str("Health: ", unit.current_health, " / ", unit.base_max_health)
	experience.text = str("XP: ", unit.current_experience, " / ", unit.base_experience)
	moves.text = str("Moves: ", unit.current_moves, " / ", unit.base_max_moves)
	# attack.text = unit.get_attack_string()

func clear_unit_info():
	health.text = str("Health: -")
	experience.text = str("XP: -")
	moves.text = str("Moves: -")
	# attack.text = str("Attack: -")
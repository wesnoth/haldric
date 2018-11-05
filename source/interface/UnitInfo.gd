extends Node2D

onready var unit_sprite = $"UnitSprite"
onready var health = $"VBox/HealthLabel"
onready var experience = $"VBox/ExperienceLabel"
onready var moves = $"VBox/MovesLabel"
onready var attack = $"AttackLabel"

func update_unit_info(unit):
	unit_sprite.texture = unit.texture
	var x = 58 + 72 - unit.texture.get_width()
	unit_sprite.position = Vector2(x, 4)
	unit_sprite.set_material(unit.get_material())
	health.text = str("HP: ", unit.current_health, "/", unit.base_max_health)
	experience.text = str("XP: ", unit.current_experience, "/", unit.base_experience)
	moves.text = str("MP: ", unit.current_moves, "/", unit.base_max_moves)
	attack.text = unit.get_attack_string()

func clear_unit_info():
	unit_sprite.texture = null
	health.text = str("")
	experience.text = str("")
	moves.text = str("")
	attack.text = str("")
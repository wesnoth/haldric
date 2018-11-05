extends Control

var Attack = preload("res://source/interface/panel/AttackItem.tscn")

onready var unit_sprite = $"Sprite"
onready var level = $"Info/Stats/Level"
onready var hp = $"Info/Stats/HP"
onready var xp = $"Info/Stats/XP"
onready var mp = $"Info/Stats/MP"

onready var attacks = $"Info/Attacks"

func update_unit_info(unit):
	
	var x = 70 + 72 - unit.texture.get_width()
	unit_sprite.texture = unit.texture
	unit_sprite.position = Vector2(x, 18)
	unit_sprite.set_material(unit.get_material())
	
	level.set_value(unit.level)
	hp.set_value(str(unit.current_health, "/", unit.base_max_health))
	xp.set_value(str(unit.current_experience, "/", unit.base_experience))
	mp.set_value(str(unit.current_moves, "/", unit.base_max_moves))
	
	remove_attacks()
	
	for attack in unit.attacks:
		add_attack(attack)

func clear_unit_info():
	unit_sprite.texture = null
	level.set_value("-")
	hp.set_value("-")
	xp.set_value("-")
	mp.set_value("-")
	remove_attacks()

func add_attack(attack_info):
	var attack = Attack.instance()
	attacks.add_child(attack)
	attack.initialize(attack_info)

func remove_attacks():
	for child in attacks.get_children():
		child.queue_free()
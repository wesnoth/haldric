extends Sprite

var side

var type

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var attack = {}
var resistance = {}

var can_attack = true

onready var lifebar = $"Lifebar"

func _ready():
	lifebar.set_max_value(current_health)
	lifebar.set_value(current_health)
	
func initialize(var reg_entry, side):
	base_max_health = reg_entry.health
	base_max_moves = reg_entry.moves
	attack = reg_entry.attack
	resistance = reg_entry.resistance
	type = reg_entry.type
	
	texture = load(reg_entry.image)
	self.side = side
	
	current_moves = base_max_moves
	current_health = base_max_health

func fight(unit):
	print("\n", "Combat starts | Counter: ", attack.range == unit.attack.range, " | Type: ", attack.type, " vs ", unit.resistance[attack.type])
	randomize()
	print(max(attack.number, unit.attack.number))
	for i in range(max(attack.number, unit.attack.number)):
		if unit.current_health > 0 and attack.number > i:
			unit.harm(type, attack.damage, attack.type, randf())
		if unit.current_health > 0 and unit.attack.number > i and attack.range == unit.attack.range:
			harm(unit.type, unit.attack.damage, unit.attack.type, randf())
	can_attack = false
	current_moves = 0

func heal(value):
	_set_current_health(current_health + value)
	print(type, " healed by ", value)

func harm(attacker_unit_type, damage, attack_type, rand):
	if rand <= 0.5:
		var mod = float(resistance[attack_type]) / 100.0
		var new_damage = damage * mod
		print("\t", attacker_unit_type, " deals ", new_damage, " damage (", damage, " * ", mod, " = ", new_damage, ")")
		_set_current_health(current_health - new_damage)
	else:
		print("\t", attacker_unit_type, " missed")

func restore_current_moves():
	current_moves = base_max_moves
	can_attack = true

func get_attack_string():
	return str("Attack: ", attack.name, " ", attack.damage, "x", attack.number, " (", attack.type, ", ", attack.range, ")")

func _set_current_health(new_health):
	if new_health <= base_max_health:
		current_health = new_health
	else:
		current_health = base_max_health
	lifebar.set_value(current_health)

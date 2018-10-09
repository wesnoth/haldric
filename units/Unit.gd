extends Sprite

var side

var type

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var attack = {}

var can_attack = true

onready var lifebar = $"Lifebar"

func _ready():
	lifebar.set_max_value(current_health)
	lifebar.set_value(current_health)
	
func initialize(var reg_entry, side):
	base_max_health = reg_entry.health
	base_max_moves = reg_entry.moves
	attack = reg_entry.attack
	type = reg_entry.type
	
	texture = load(reg_entry.image)
	self.side = side
	
	current_moves = base_max_moves
	current_health = base_max_health

func fight(unit):
	print("\n", "Combat starts | Counter: ", attack.range == unit.attack.range)
	randomize()
	for i in range(attack.number):
		if unit.current_health > 0:
			unit.harm(attack.damage, randf())
			if unit.current_health > 0 and unit.attack.number > i and attack.range == unit.attack.range:
				harm(unit.attack.damage, randf())
	can_attack = false
	current_moves = 0

func harm(damage, rand):
	if rand <= 0.5:
		print("\t", type, " gets ", damage, " damage")
		_set_current_health(current_health - damage)
	else:
		print("\t", type, " missed")

func restore_current_moves():
	current_moves = base_max_moves
	can_attack = true

func get_attack_string():
	return str("Attack: ", attack.name, " ", attack.damage, "x", attack.number, " (", attack.type, ", ", attack.range, ")")

func _set_current_health(health):
	current_health = health
	lifebar.set_value(health)

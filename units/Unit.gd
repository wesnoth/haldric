extends Sprite

var side

var id
var level

var advances_to

var base_experience
var current_experience

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var attack = {}
var resistance = {}
var defense = {}
var movement = {}

var can_attack = true

onready var lifebar = $"Lifebar"

func _ready():
	update_lifebar()

func _process(delta):
	if current_experience >= base_experience and advances_to == null:
		amla()
	elif current_experience >= base_experience and UnitRegistry.registry.has(advances_to):
		advance(UnitRegistry.registry[advances_to])


func initialize(reg_entry, side):
	id = reg_entry.id
	level = reg_entry.level
	base_max_health = reg_entry.health
	current_health = base_max_health
	base_max_moves = reg_entry.moves
	current_moves = base_max_moves
	base_experience = reg_entry.experience
	current_experience = 0
	advances_to = reg_entry.advances_to
	attack = reg_entry.attack
	resistance = reg_entry.resistance
	defense = reg_entry.defense
	defense["impassable"] = 0
	movement = reg_entry.movement
	movement["impassable"] = 99
	texture = load(reg_entry.image)
	self.side = side

func advance(reg_entry):
	id = reg_entry.id
	level = reg_entry.level
	base_max_health = reg_entry.health
	current_health = base_max_health
	base_max_moves = reg_entry.moves
	base_experience = reg_entry.experience
	current_experience = 0
	attack = reg_entry.attack
	resistance = reg_entry.resistance
	defense = reg_entry.defense
	defense["impassable"] = 0
	movement = reg_entry.movement
	movement["impassable"] = 99
	texture = load(reg_entry.image)
	update_lifebar()

func amla():
	base_max_health += 3
	_set_current_health(base_max_health)
	update_lifebar()
	var left_over = current_experience - base_experience 
	base_experience = int(base_experience * 1.2)
	current_experience = left_over

func heal(value):
	_set_current_health(current_health + value)
	print(id, " healed by ", value)

func harm(attacker_unit_id, damage, attack_type, defense):
	var hit_chance = float(100 - defense) / 100.0
	print("Hit Chance: ", hit_chance)
	if randf() <= hit_chance:
		var mod = float(resistance[attack_type]) / 100.0
		var new_damage = damage * mod
		print("\t", attacker_unit_id, " deals ", new_damage, " damage (", damage, " * ", mod, " = ", new_damage, ")")
		_set_current_health(current_health - new_damage)
	else:
		print("\t", attacker_unit_id, " missed")

func restore_current_moves():
	current_moves = base_max_moves
	can_attack = true

func has_moved():
	return current_moves == base_max_moves

func get_attack_string():
	return str("Attack: ", attack.name, " ", attack.damage, "x", attack.strikes, " (", attack.type, ", ", attack.range, ")")

func update_lifebar():
	lifebar.set_max_value(base_max_health)
	lifebar.set_value(current_health)

func get_movement_cost(terrain_type):
	if terrain_type[1] == "":
		return movement[terrain_type[0]]
	if movement[terrain_type[0]] > movement[terrain_type[1]] :
		return movement[terrain_type[0]]
	else:
		return movement[terrain_type[1]]

func get_defense(terrain_type):
	if terrain_type[1] == "":
		return defense[terrain_type[0]]
	if defense[terrain_type[0]] > defense[terrain_type[1]] :
		return defense[terrain_type[0]]
	else:
		return defense[terrain_type[1]]

func get_map_position():
	return get_node("../..").terrain.world_to_map(position)

func get_adjacent_units():
	var units = []
	for cell in get_node("../..").terrain._get_neighbors(get_map_position()):
		var otherUnit = get_node("../..").get_unit_at_cell(cell)
		if otherUnit:
			units.append(otherUnit)
	return units
func _set_current_health(new_health):
	if new_health <= base_max_health:
		current_health = new_health
	else:
		current_health = base_max_health
	lifebar.set_value(current_health)
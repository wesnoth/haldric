extends Sprite

# I N T E R N A L   V A R I A B L E S 

var side
var tile_path = []

var can_attack = true
var is_leader = false

# Y A M L   S T A T S

var numerical_id
var string_id
var type
var race

var level

var cost
var advances_to

var alignment

var base_experience
var current_experience setget _set_current_experience

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var current_defense = 0

var abilities = {}

var attacks = {}
var resistance = {}
var defense = {}
var movement = {}


var game
onready var anim = $"AnimationPlayer"
onready var tween = $"Tween"
onready var lifebar = $"Lifebar"
onready var xpbar = $"XPbar"

func _ready():
	current_defense = get_defense(get_current_tile().terrain_type)
	update_lifebar()
	update_xpbar()

func _process(delta):
	_handle_movement()
	
	if current_experience >= base_experience and advances_to == null:
		amla()
	elif current_experience >= base_experience and Registry.units.has(advances_to):
		advance(Registry.units[advances_to])


func initialize(config, side, id = ""):
	if id == "":
		string_id = str(config.id , Wesnoth.UNIT_ID)
	else:
		string_id = id
	name = string_id
	numerical_id = Wesnoth.UNIT_ID
	Wesnoth.UNIT_ID += 1
	
	type = config.id
	level = config.level
	race = config.race
	cost = config.cost
	alignment = config.alignment
	base_max_health = config.health
	current_health = base_max_health
	base_max_moves = config.moves
	current_moves = base_max_moves
	base_experience = config.experience
	current_experience = 0
	advances_to = config.advances_to
	abilities = config.abilities
	attacks = config.attacks
	resistance = config.resistance
	defense = config.defense
	defense["impassable"] = 0
	movement = config.movement
	movement["impassable"] = 99
	texture = load(config.image)
	self.side = side

func advance(config):
	type = config.id
	level = config.level
	race = config.race
	cost = config.cost
	alignment = config.alignment
	base_max_health = config.health
	current_health = base_max_health
	base_max_moves = config.moves
	base_experience = config.experience
	current_experience = 0
	attacks = config.attacks
	resistance = config.resistance
	defense = config.defense
	defense["impassable"] = 0
	movement = config.movement
	movement["impassable"] = 99
	texture = load(config.image)
	update_lifebar()
	update_xpbar()

func amla():
	base_max_health += 3
	_set_current_health(base_max_health)
	update_lifebar()
	var left_over = current_experience - base_experience 
	base_experience = int(base_experience * 1.2)
	current_experience = left_over
	update_xpbar()

func heal(value):
	_set_current_health(current_health + value)

func harm(value):
	_set_current_health(current_health - value)

func restore_current_moves():
	current_moves = base_max_moves
	can_attack = true

func has_moved():
	return current_moves < base_max_moves

func get_attack_string():
	var string = ""
	for attack in attacks:
		string += str(attack.name, ": ", attack.damage, "x", attack.strikes, " (", attack.type, ", ", attack.range, ")\n")
	return string

func update_lifebar():
	lifebar.set_max_value(base_max_health)
	lifebar.set_value(current_health)

func update_xpbar():
	xpbar.set_max_value(base_experience)
	xpbar.set_value(current_experience)

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
	return game.terrain.world_to_map(position)

func get_current_tile():
	return game.terrain.tiles[game.terrain.flatten_v(get_map_position())]

func get_adjacent_units():
	var units = []
	for cell in game.terrain._get_neighbors(get_map_position()):
		var other_unit = game.get_unit_at_cell(cell)
		if other_unit:
			units.append(other_unit)
	return units

func get_adjacent_cells():
	return game.terrain._get_neighbors(get_map_position())

func _set_current_experience(value):
	current_experience = value
	update_xpbar()

func _set_current_health(value):
	if value <= base_max_health:
		current_health = value
	else:
		current_health = base_max_health
	update_lifebar()

func move(tile_path):
	self.tile_path = tile_path
	self.tile_path.remove(0)

func _handle_movement():
	set_process(false)

	if tile_path.size() > 0 and current_moves - get_movement_cost(tile_path[0].terrain_type) >= 0:
		get_current_tile().unit = null
		anim.play("walk")
		tween.interpolate_property(self, "position", position, tile_path[0].position, anim.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween.start()
		yield(anim, "animation_finished")
		position = tile_path[0].position
		current_moves -= get_movement_cost(tile_path[0].terrain_type)
		tile_path.remove(0)
		Wesnoth.emit_signal("unit_moved", "moveto", self)

		if _is_in_zoc():
			get_current_tile().unit = self
			current_moves = 0
			tile_path = []
			current_defense = get_defense(get_current_tile().terrain_type)
			Wesnoth.emit_signal("unit_move_finished", self)
		
		elif tile_path.size() == 0 or current_moves - get_movement_cost(tile_path[0].terrain_type) < 0:
			get_current_tile().unit = self
			tile_path = []
			current_defense = get_defense(get_current_tile().terrain_type)
			Wesnoth.emit_signal("unit_move_finished", self)
	
	set_process(true)

func _is_in_zoc():
	var adjacent_units = get_adjacent_units()
	for unit in adjacent_units:
		if unit.side != side and unit.level > 0:
			return true
	return false
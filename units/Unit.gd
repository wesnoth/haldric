extends Sprite

var attributes

var side

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var damage

var can_attack = true

onready var lifebar = $"Lifebar"

func _ready():
	lifebar.set_max_value(current_health)
	lifebar.set_value(current_health)
	
func initialize(var reg_entry, side):
	base_max_health = reg_entry.health
	base_max_moves = reg_entry.moves
	damage = reg_entry.damage
	
	texture = load(reg_entry.image)
	self.side = side
	
	current_moves = base_max_moves
	current_health = base_max_health

func fight(unit):
	unit.harm(damage)
	can_attack = false
	current_moves = 0
	
	if unit.current_health > 0:
		harm(unit.damage)

func harm(damage):
	_set_current_health(current_health - damage)

func restore_current_moves():
	current_moves = base_max_moves
	can_attack = true

func _set_current_health(health):
	current_health = health
	lifebar.set_value(health)

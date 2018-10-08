extends Node

var attributes

var side

var base_max_health
var base_max_moves

var current_health setget _set_current_health
var current_moves

var damage

var can_attack = true

onready var lifebar = $"Lifebar"

func fight(unit):
	unit.harm(damage)
	can_attack = false
	current_moves = 0
	
	if unit.current_health > 0:
		harm(unit.damage)

func harm(damage):
	_set_current_health(current_health - damage)

func _set_current_health(health):
	current_health = health
	lifebar.value = health

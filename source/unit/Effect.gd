extends Node
class_name Effect

export(String, "heal", "hurt", "modify") var type = "hurt"

export var args := []

"""
DAMAGE [
	damage
	damage_type
]


HEAL [
	amount
]

MODIFY [
	property
	value
]
"""

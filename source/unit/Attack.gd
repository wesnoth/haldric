extends Node
class_name Attack

export var id := ""
export(String, "ranged", "melee") var reach := ""
export(String, "blade", "pierce", "impact", "fire", "cold", "arcane") var type := ""
export var damage := 0
export var strikes := 0
export var icon : StreamTexture = null

onready var specials := get_children()

func execute_before_turn(user, target):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_before_turn_to_enemy"):
				child.execute_before_turn_to_enemy(target)
			if child.has_method("execute_before_turn_to_user"):
				child.execute_before_turn_to_user(user)
			if child.has_method("execute_before_turn_on_weapon"):
				child.execute_before_turn_on_weapon(self)

func execute_each_turn(user, target):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_each_turn_to_enemy"):
				child.execute_each_turn_to_enemy(target)
			if child.has_method("execute_each_turn_to_user"):
				child.execute_each_turn_to_user(user)
			if child.has_method("execute_each_turn_on_weapon"):
				child.execute_each_turn_on_weapon(self)

func execute_end_turn(user, target):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_end_turn_to_enemy"):
				child.execute_end_turn_to_enemy(target)
			if child.has_method("execute_end_turn_to_user"):
				child.execute_end_turn_to_user(user)
			if child.has_method("execute_end_turn_on_weapon"):
				child.execute_end_turn_on_weapon(self)

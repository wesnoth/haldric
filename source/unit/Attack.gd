extends Node
class_name Attack

export var id := ""
export(String, "ranged", "melee") var reach := ""
export(String, "blade", "pierce", "impact", "fire", "cold", "arcane") var type := ""
export var damage := 0
export var strikes := 0
export var icon : StreamTexture = null

onready var specials := get_children()

func execute_before_turn(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_before_turn_to_enemy"):
				child.execute_before_turn_to_enemy(target, isAttacking)
			if child.has_method("execute_before_turn_to_user"):
				child.execute_before_turn_to_user(user, isAttacking)
			if child.has_method("execute_before_turn_on_weapon"):
				child.execute_before_turn_on_weapon(self, isAttacking)

func execute_each_turn(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_each_turn_to_enemy"):
				child.execute_each_turn_to_enemy(target, isAttacking)
			if child.has_method("execute_each_turn_to_user"):
				child.execute_each_turn_to_user(user, isAttacking)
			if child.has_method("execute_each_turn_on_weapon"):
				child.execute_each_turn_on_weapon(self, isAttacking)

func execute_user_hit(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_user_hit_to_enemy"):
				child.execute_user_hit_to_enemy(target, isAttacking)
			if child.has_method("execute_user_hit_to_user"):
				child.execute_user_hit_to_user(user, isAttacking)
			if child.has_method("execute_user_hit_to_weapon"):
				child.execute_user_hit_to_weapon(self, isAttacking)

func execute_user_miss(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_user_miss_to_enemy"):
				child.execute_user_miss_to_enemy(target, isAttacking)
			if child.has_method("execute_user_miss_to_user"):
				child.execute_user_miss_to_user(user, isAttacking)
			if child.has_method("execute_user_miss_on_weapon"):
				child.execute_user_miss_on_weapon(self, isAttacking)

func execute_enemy_hit(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_enemy_hit_to_enemy"):
				child.execute_enemy_hit_to_enemy(target, isAttacking)
			if child.has_method("execute_enemy_hit_to_user"):
				child.execute_enemy_hit_to_user(user, isAttacking)
			if child.has_method("execute_enemy_hit_to_weapon"):
				child.execute_enemy_hit_to_weapon(self, isAttacking)

func execute_enemy_miss(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_enemy_miss_to_enemy"):
				child.execute_enemy_miss_to_enemy(target, isAttacking)
			if child.has_method("execute_enemy_miss_to_user"):
				child.execute_enemy_miss_to_user(user, isAttacking)
			if child.has_method("execute_enemy_miss_on_weapon"):
				child.execute_enemy_miss_on_weapon(self, isAttacking)

func execute_end_turn(user, target, isAttacking):
	if specials and not specials.empty():
		for child in specials:
			if child.has_method("execute_end_turn_to_enemy"):
				child.execute_end_turn_to_enemy(target, isAttacking)
			if child.has_method("execute_end_turn_to_user"):
				child.execute_end_turn_to_user(user, isAttacking)
			if child.has_method("execute_end_turn_on_weapon"):
				child.execute_end_turn_on_weapon(self, isAttacking)

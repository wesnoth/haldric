extends Node
class_name WeaponSpecial

func execute_before_turn_to_enemy(target : Unit, isAttacking : bool):
	pass

func execute_each_turn_to_enemy(target : Unit, isAttacking : bool):
	pass

func execute_end_turn_to_enemy(target : Unit, isAttacking : bool):
	pass

func execute_before_turn_to_user(user : Unit, isAttacking : bool):
	pass

func execute_each_turn_to_user(user : Unit, isAttacking : bool):
	pass

func execute_end_turn_to_user(user : Unit, isAttacking : bool):
	pass

func execute_before_turn_on_weapon(weapon : Attack, isAttacking : bool):
	pass

func execute_each_turn_on_weapon(weapon : Attack, isAttacking : bool):
	pass

func execute_end_turn_on_weapon(weapon : Attack, isAttacking : bool):
	pass

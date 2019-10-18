extends "res://source/unit/WeaponSpecial.gd"
class_name Swift_test

func execute_before_turn_on_weapon(weapon: Attack):
	print("gain one extra attack")
	weapon.strikes += 1

func execute_end_turn_on_weapon(weapon: Attack):
	print("return to normal")
	weapon.strikes -= 1
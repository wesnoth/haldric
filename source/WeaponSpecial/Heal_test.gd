extends "res://source/unit/WeaponSpecial.gd"

func execute_each_turn_to_user(user : Unit):
	print("the unit heal!")
	user.health_current += 2
	if user.health_current > user.type.health:
		user.health_current =  user.type.health
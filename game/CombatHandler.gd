extends Node

func start_fight(attacker, attacker_terrain, defender, defender_terrain):
	
	randomize()
	
	print("\n", "Combat starts | Counter: ", attacker.attack.range == defender.attack.range, " | Type: ", attacker.attack.type, "(", defender.resistance[attacker.attack.type], ")")
	
	for i in range(max(attacker.attack.strikes, defender.attack.strikes)):

		if attacker.current_health > 0:
			if attacker.attack.strikes > i:
				defender.harm(attacker.type, attacker.attack.damage, attacker.attack.type, defender_terrain)
		else:
			attacker.can_attack = false
			attacker.current_moves = 0
			attacker.queue_free()
			return

		if defender.current_health > 0:
			if defender.attack.strikes > i and attacker.attack.range == defender.attack.range:
				attacker.harm(defender.type, defender.attack.damage, defender.attack.type, attacker_terrain)
		else:
			defender.queue_free()
			return

	attacker.can_attack = false
	attacker.current_moves = 0
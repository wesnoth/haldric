extends Node

const xp_per_level = 8

func start_fight(attacker, attacker_defense, defender, defender_defense):
	
	randomize()
	
	print("\n", "Combat starts | Counter: ", attacker.attack.range == defender.attack.range, " | Type: ", attacker.attack.type, "(", defender.resistance[attacker.attack.type], ")")
	
	for i in range(max(attacker.attack.strikes, defender.attack.strikes)):

		if attacker.current_health > 0:
			if attacker.attack.strikes > i:
				defender.harm(attacker.id, attacker.attack.damage, attacker.attack.type, defender_defense)
		else:
			if attacker.level > 0:
				defender.current_experience += attacker.level * xp_per_level
			else:
				defender.current_experience += xp_per_level / 2
			attacker.queue_free()
			return

		if defender.current_health > 0:
			if defender.attack.strikes > i and attacker.attack.range == defender.attack.range:
				attacker.harm(defender.id, defender.attack.damage, defender.attack.type, attacker_defense)
		else:
			if defender.level > 0:
				attacker.current_experience += defender.level * xp_per_level
			else:
				attacker.current_experience += xp_per_level / 2
			defender.queue_free()
			return

	attacker.can_attack = false
	attacker.current_moves = 0
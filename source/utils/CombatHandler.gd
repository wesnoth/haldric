extends Node

const xp_per_level = 8

func start_fight(attacker, attacker_info, defender, defender_info):
	
	randomize()
	
	print("\n", "Combat starts | Counter: ", attacker_info.attack.range == defender_info.attack.range, " | Type: ", attacker_info.attack.type, "(", defender.resistance[attacker_info.attack.type], ")")
	
	for i in range(max(attacker_info.attack.strikes, defender_info.attack.strikes)):

		if attacker.current_health > 0:
			if attacker_info.attack.strikes > i:
				defender.harm(attacker.id, attacker_info.attack.damage, attacker_info.attack.type, defender_info.defense)
		else:
			if attacker.level > 0:
				defender.current_experience += attacker.level * xp_per_level
			else:
				defender.current_experience += xp_per_level / 2
			if attacker.is_leader:
				get_parent().sides[attacker.side-1].leaders.erase(attacker)
			attacker.queue_free()
			return

		if defender.current_health > 0:
			if defender_info.attack.strikes > i and attacker_info.attack.range == defender_info.attack.range:
				attacker.harm(defender.id, defender_info.attack.damage, defender_info.attack.type, attacker_info.defense)
		else:
			if defender.level > 0:
				attacker.current_experience += defender.level * xp_per_level
			else:
				attacker.current_experience += xp_per_level / 2
			if defender.is_leader:
				get_parent().sides[defender.side-1].leaders.erase(defender)
			defender.queue_free()
			return

	attacker.current_experience += defender.level
	defender.current_experience += attacker.level
	
	attacker.can_attack = false
	attacker.current_moves = 0
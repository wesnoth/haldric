extends Node

const xp_per_level = 8

func start_fight(attacker, attack_id, attacker_defense, defender, defend_id, defender_defense):
	
	randomize()
	
	print("\n", "Combat starts | Counter: ", attacker.attacks[attack_id].range == defender.attacks[defend_id].range, " | Type: ", attacker.attacks[attack_id].type, "(", defender.resistance[attacker.attacks[attack_id].type], ")")
	
	for i in range(max(attacker.attacks[attack_id].strikes, defender.attacks[defend_id].strikes)):

		if attacker.current_health > 0:
			if attacker.attacks[attack_id].strikes > i:
				defender.harm(attacker.id, attacker.attacks[attack_id].damage, attacker.attacks[attack_id].type, defender_defense)
		else:
			if attacker.level > 0:
				defender.current_experience += attacker.level * xp_per_level
			else:
				defender.current_experience += xp_per_level / 2
			attacker.queue_free()
			return

		if defender.current_health > 0:
			if defender.attacks[defend_id].strikes > i and attacker.attacks[attack_id].range == defender.attacks[defend_id].range:
				attacker.harm(defender.id, defender.attacks[defend_id].damage, defender.attacks[defend_id].type, attacker_defense)
		else:
			if defender.level > 0:
				attacker.current_experience += defender.level * xp_per_level
			else:
				attacker.current_experience += xp_per_level / 2
			defender.queue_free()
			return

	attacker.current_experience += defender.level
	defender.current_experience += attacker.level
	
	attacker.can_attack = false
	attacker.current_moves = 0
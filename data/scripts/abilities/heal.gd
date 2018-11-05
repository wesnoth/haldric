extends Resource

var config = {
	name = "Heal",
	event = "turn refresh",
	value = 8
}

func heal(unit, config):
	var adjacent_units = unit.get_adjacent_units()
	for u in adjacent_units:
		if unit.side == u.side:
			u.heal(config.value)
			print(unit.type, " healed ", u.type, " by ", config.value, " HP")
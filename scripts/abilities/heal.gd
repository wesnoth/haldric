extends Resource

var name = "Heal"

var default = {
	value = 8
}

func heal(unit, params):
	var adjacent_units = unit.get_adjacent_units()
	for u in adjacent_units:
		if unit.side == u.side:
			u.heal(params.value)
			print(unit.id, " healed ", u.id, " by ", params.value, " HP")
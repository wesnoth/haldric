extends Resource

func regenerate(unit, params):
	unit.heal(params.value)
	print(unit.id, " regenerated ", params.value, " HP")
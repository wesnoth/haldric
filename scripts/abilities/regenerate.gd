extends Resource

var name = "Regenerate"

var default = {
	value = 8
}

func regenerate(unit, params):
	unit.heal(params.value)
	print(unit.id, " regenerated ", params.value, " HP")
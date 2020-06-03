extends Node
class_name Time

export var alias := ""

export var color := Color("FFFFFF")

export var tint_red := 0
export var tint_green := 0
export var tint_blue := 0

export(Array, String) var advantage := []
export(Array, String) var disadvantage := []

export(int, 0, 100) var bonus := 0
export(int, 0, 100) var malus := 0


func get_modifier(alignment: String) -> float:
	var mod := 1.0

	if advantage.has(alignment):
		mod += float(bonus) / 100.0

	if disadvantage.has(alignment):
		mod -= float(malus) / 100.0

	return mod

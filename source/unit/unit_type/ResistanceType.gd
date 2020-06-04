extends Node
class_name ResistanceType

var types = [ "slash", "impact", "pierce", "burn", "frost", "arcane" ]

# physical Types
export(int, -100, 100, 5) var slash := 0
export(int, -100, 100, 5) var impact := 0
export(int, -100, 100, 5) var pierce := 0
export(int, -100, 100, 5) var burn := 0
export(int, -100, 100, 5) var frost := 0
export(int, -100, 100, 5) var arcane := 0


func calculate_damage(damage: int, type: String) -> int:
	return damage * (1.0 - get(type) / 100)


func to_string() -> String:
	var s = "Resistances:\n"
	for type in types:
		s += "%s: %d\n" % [type.to_lower(), get(type.to_lower())]
	return s

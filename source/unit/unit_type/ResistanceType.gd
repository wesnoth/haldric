extends Node
class_name ResistanceType

# physical Types
export(int, -100, 100, 5) var slash := 0
export(int, -100, 100, 5) var impact := 0
export(int, -100, 100, 5) var pierce := 0

# natural types
export(int, -100, 100, 5) var nature := 0
export(int, -100, 100, 5) var burn := 0
export(int, -100, 100, 5) var frost := 0
export(int, -100, 100, 5) var shock := 0
export(int, -100, 100, 5) var sonic := 0

# magical types
export(int, -100, 100, 5) var arcane := 0
export(int, -100, 100, 5) var holy := 0
export(int, -100, 100, 5) var chaos := 0


func calculate_damage(damage: int, type: String) -> int:
	return damage * (1.0 - get(type) / 100)


func to_string() -> String:
	var s = "Resistances:\n"
	for type in Attack.DamageType.keys():
		if type == "NONE":
			continue

		s += "%s: %d\n" % [type.to_lower(), get(type.to_lower())]
	return s

extends Node
class_name DayTime

# TODO: use 3 ints?
export var color_adjust := Vector3(0, 0, 0)

export(Array, String) var advantage := []
export(Array, String) var disadvantage := []

export(int, 0, 100) var bonus := 0
export(int, 0, 100) var malus := 0

func get_percentage(alignment: String) -> int:
	if advantage.has(alignment):
		return bonus
	elif disadvantage.has(alignment):
		return -malus
	else:
		return 0
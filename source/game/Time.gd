extends Node
class_name Time

# TODO: use 3 ints?
var tint = {}

var advantage := []
var disadvantage := []

var bonus := 0
var malus := 0

func initialize(res: RTime) -> void:
	advantage = res.advantage
	disadvantage = res.disadvantage
	bonus = res.bonus
	malus = res.malus
	tint.red = res.tint_red
	tint.green = res.tint_green
	tint.blue = res.tint_blue

func get_percentage(alignment: String) -> int:
	if advantage.has(alignment):
		return bonus
	elif disadvantage.has(alignment):
		return -malus
	else:
		return 0
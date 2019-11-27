extends Node
class_name Time

var tint := Vector3()
var color := Color("FFFFFF")

var advantage := []
var disadvantage := []

var bonus := 0
var malus := 0

var sound: AudioStream = null

func _init(res: RTime) -> void:
	name = res.name

	advantage = res.advantage
	disadvantage = res.disadvantage

	bonus = res.bonus
	malus = res.malus

	tint[0] = res.tint_red
	tint[1] = res.tint_green
	tint[2] = res.tint_blue

	color = res.color

	if res.sound:
		sound = load(res.sound)

func get_percentage(alignment: String) -> int:
	if advantage.has(alignment):
		return bonus
	elif disadvantage.has(alignment):
		return -malus
	else:
		return 0

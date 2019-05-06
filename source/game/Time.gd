extends Node
class_name Time

var tint := Vector3()

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

	if res.sound:
		# TODO: we want to be able to load WAV sounds too... why the hell is
		# AudioStreamOGGVorbis the only thing with looping controls??? O_O
		sound = load(res.sound) as AudioStreamOGGVorbis
		sound.loop = false

func get_percentage(alignment: String) -> int:
	if advantage.has(alignment):
		return bonus
	elif disadvantage.has(alignment):
		return -malus
	else:
		return 0

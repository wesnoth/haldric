extends Control

onready var level = $"Stats/Level"
onready var hp = $"Stats/HP"
onready var xp = $"Stats/XP"
onready var mp = $"Stats/MP"

func ready():
	level.set_value(" ")

func update_unit_stats(unit):
	level.set_stat(unit.level)
	hp.set_value(str(unit.current_health, "/", unit.base_max_health))
	xp.set_value(str(unit.current_experience, "/", unit.base_experience))
	mp.set_value(str(unit.current_moves, "/", unit.base_max_moves, " | ", unit.current_defense, "%"))
	show()

func clear_unit_stats():
	hide()
	hp.set_value("-")
	xp.set_value("-")
	mp.set_value("-")
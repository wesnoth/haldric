extends Control

onready var hp = $"Stats/HP"
onready var xp = $"Stats/XP"
onready var mp = $"Stats/MP"

func update_unit_stats(unit):
	hp.set_value(str(unit.current_health, "/", unit.base_max_health))
	xp.set_value(str(unit.current_experience, "/", unit.base_experience))
	mp.set_value(str(unit.current_moves, "/", unit.base_max_moves, " | ", unit.current_defense, "%"))
	show()

func clear_unit_stats():
	hide()
	hp.set_value("-")
	xp.set_value("-")
	mp.set_value("-")
extends Control

onready var unit_sprite = $"Sprite"
onready var level = $"Stats/Level"
onready var hp = $"Stats/HP"
onready var xp = $"Stats/XP"
onready var mp = $"Stats/MP"

func ready():
	level.set_value(" ")

func update_unit_info(unit):
	var x = 65 + 72 - unit.texture.get_width()
	unit_sprite.texture = unit.texture
	unit_sprite.position = Vector2(x, 40)
	unit_sprite.set_material(unit.get_material())
	
	level.set_stat(unit.level)
	hp.set_value(str(unit.current_health, "/", unit.base_max_health))
	xp.set_value(str(unit.current_experience, "/", unit.base_experience))
	mp.set_value(str(unit.current_moves, "/", unit.base_max_moves))
	show()

func clear_unit_info():
	hide()
	unit_sprite.texture = null
	hp.set_value("-")
	xp.set_value("-")
	mp.set_value("-")
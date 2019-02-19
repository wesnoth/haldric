extends Control

onready var level = $"LevelPlate/Label"
onready var unit_name = $"Info/Name"
onready var type = $"Info/Type"
onready var alignment = $"Info/Alignment"
onready var race = $"Info/Race"

func update_unit_info(unit):
	level.text = str(unit.level)
	unit_name.set_text(str(unit.name))
	type.set_text(str(unit.type))
	alignment.set_text(str(unit.alignment))
	race.set_text(str(unit.race))
	show()

func clear_unit_info():
	hide()
	level.text = "-"
	unit_name.set_text("-")
	type.set_text("-")
	alignment.set_text("-")
	race.set_text("-")

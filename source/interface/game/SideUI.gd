extends Control
class_name SideUI


onready var side_label := $HBoxContainer/Side
onready var gold_label := $HBoxContainer/Gold
onready var income_label := $HBoxContainer/Income
onready var villages_label := $HBoxContainer/Villages
onready var units_label := $HBoxContainer/Units


func update_info(side: Side) -> void:
	side_label.text = "Side: %d" % (side.number + 1)
	gold_label.text = "Gold: %d" % side.gold
	income_label.text = "Income: %d (-%d)" % [ side.income, side.upkeep ]
	villages_label.text = "Villages: %d" % side.villages.size()
	units_label.text = "Units: %d" % side.units.size()

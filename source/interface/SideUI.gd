extends Panel
class_name Side_UI


onready var side_label := $HBoxContainer/Side
onready var gold_label := $HBoxContainer/Gold
onready var income_label := $HBoxContainer/Income
onready var towns_label := $HBoxContainer/Towns
onready var units_label := $HBoxContainer/Units


func update_info(side: Side) -> void:
	side_label.text = "Side: %d" % (side.number + 1)
	gold_label.text = "Gold: %d" % side.gold
	income_label.text = "Income: %d (-%d)" % [ side.income, side.upkeep ]
	towns_label.text = "Towns: %d" % side.towns.size()
	units_label.text = "Units: %d" % side.units.size()

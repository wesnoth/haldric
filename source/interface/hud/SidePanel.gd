extends Control

onready var flag = $HBoxContainer/Flag as SidePanelItem
onready var gold = $HBoxContainer/Gold as SidePanelItem
onready var villages = $HBoxContainer/Villages as SidePanelItem
onready var units = $HBoxContainer/Units as SidePanelItem
onready var upkeep = $HBoxContainer/Upkeep as SidePanelItem
onready var income = $HBoxContainer/Income as SidePanelItem
onready var battery = $HBoxContainer/Battery as SidePanelItem
onready var time = $HBoxContainer/Time as SidePanelItem

func _process(delta):
	time.set_text(_get_time_string())
	battery.set_text(str(OS.get_power_percent_left(), " %"))
	if OS.get_power_percent_left() == -1:
		battery.hide()

func update_side(scenario : Scenario, side : Side) -> void:
	flag.set_text(str(side.side))
	gold.set_text(str(side.gold))
	units.set_text(str(side.units.get_child_count()))
	upkeep.set_text(str(side.upkeep))
	villages.set_text(str(side.villages.size(), "/", scenario.get_village_count()))
	income.set_text(str(side.income))


func _get_time_string() -> String:
	var time = OS.get_time()
	var hour = time.hour
	var minute = time.minute
	return str(hour).pad_zeros(2) + " : " + str(minute).pad_zeros(2)

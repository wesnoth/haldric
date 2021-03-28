extends Node

var combat_start_event_ind
var move_start_event_ind
var recruit_event_ind

func _ready():
	EventBus.connect("start", self, "_on_start")
	EventBus.connect("move_finished", self, "_on_move")

func _on_start(scenario):
	if not Campaign.recall_list.has("Humans"):
		scenario.add_unit(1, "Lieutenant", 5, 4, true)
		return

	for unit in Campaign.recall_list["Humans"]:
		if unit.is_leader:
			var location = scenario.map.get_location_from_cell(Vector2(5, 4))
			scenario.recall(unit.id, unit, location, true)
	scenario.show_info_dialogue("Wesnoth", "Move to the eastern border of the map")

func _on_move(scenario, side, start_loc, end_loc):
	if side.recall_side == "Humans" and end_loc.cell.x > 27:
		scenario.victory()
		scenario.show_info_dialogue("Heinz", "We escaped!")

extends Node

var combat_start_event_ind
var move_start_event_ind
var recruit_event_ind

func _ready():
	EventBus.add_listener("start", self, "_on_start")
	combat_start_event_ind = EventBus.add_listener("combat_start", self, "_on_combat")
	move_start_event_ind = EventBus.add_listener("move_start", self, "_on_move")
	recruit_event_ind = EventBus.add_listener("recruit", self, "_on_recruit")

func _on_start(data):
	var scenario = data.scenario
	scenario.show_info_dialogue("Wesnoth", "Hello Haldric player! This is a tutorial.")
	scenario.show_info_dialogue("Wesnoth", 
	"""To select, click on the unit
	To move, select your unit then click on your destination
	To attack, select your unit then click on the other unit.
	To open a skills menu, left click on your unit.
	To recruit, open a skills menu and click 'RE'
	To recall, open a skills menu and click 'RA'""")

func _on_combat(data):
	var scenario = data.scenario
	if (data.attacker_side.controller == Side.Controller.HUMAN):
		scenario.show_info_dialogue("Wesnoth", "Good Job! This is combat in Haldric.")
		EventBus.remove_listener("combat_start", combat_start_event_ind)

func _on_move(data):
	var scenario = data.scenario
	if (data.side.controller == Side.Controller.HUMAN):
		scenario.show_info_dialogue("Wesnoth", "That is how you move in Haldric.")
		EventBus.remove_listener("move_start", move_start_event_ind)

func _on_recruit(data):
	var scenario = data.scenario
	if (data.side.controller == Side.Controller.HUMAN):
		scenario.show_info_dialogue("Wesnoth", "You just recruited some troops!")
		EventBus.remove_listener("recruit", recruit_event_ind)

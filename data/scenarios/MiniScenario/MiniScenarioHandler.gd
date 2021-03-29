extends Node

var combat_start_event_ind
var move_start_event_ind
var recruit_event_ind

func _ready():
	EventBus.connect("start", self, "_on_start")
	EventBus.connect("combat_start", self, "_on_combat")
	EventBus.connect("move_start", self, "_on_move")
	EventBus.connect("recruit", self, "_on_recruit")

func _on_start(scenario):
	scenario.show_info_dialogue("Wesnoth", "Hello Haldric player! This is a tutorial.")
	scenario.show_info_dialogue("Wesnoth", 
	"""To select, click on the unit
	To move, select your unit then click on your destination
	To attack, select your unit then click on the other unit.
	To open a skills menu, left click on your unit.
	To recruit, open a skills menu and click 'RE'
	To recall, open a skills menu and click 'RA'""")

var combat_first = true
func _on_combat(scenario, attacker_side, attacker_loc, attacker_attack, defender_side, defender_loc, defender_attack):
	if combat_first:
		if (attacker_side.controller == Side.Controller.HUMAN):
			scenario.show_info_dialogue("Wesnoth", "Good Job! This is combat in Haldric.")
		combat_first = false

var move_first = true
func _on_move(scenario, side, start_loc, end_loc):
	if move_first:
		if (side.controller == Side.Controller.HUMAN):
			scenario.show_info_dialogue("Wesnoth", "That is how you move in Haldric.")
		move_first = false

var recruit_first = true
func _on_recruit(scenario, side, unit, loc):
	if recruit_first:
		if (side.controller == Side.Controller.HUMAN):
			scenario.show_info_dialogue("Wesnoth", "You just recruited some troops!")
		recruit_first = false

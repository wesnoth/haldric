extends Node

signal start(scenario)

signal prerecruit(scenario, side, unit, loc)
signal recruit(scenario, side, unit, loc)

signal prerecall(scenario, side, unit, loc)
signal recall(scenario, side, unit, loc)

signal add_unit(scenario, side, unit, loc, is_leader)
signal place_unit(scenario, side, unit, loc)

signal combat_start(scenario,
	attacker_side, attacker_loc, attacker_attack,
	defender_side, defender_loc, defender_attack)
signal combat_finished(scenario,
	attacker_side, attacker_loc, attacker_attack,
	defender_side, defender_loc, defender_attack)

signal next_turn(scenario, turn)
signal next_side(scenario, turn, new_side)

signal move_start(scenario, side, start_loc, end_loc)
signal move_finished(scenario, side, start_loc, end_loc)

signal victory(scenario, side)

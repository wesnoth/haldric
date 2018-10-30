extends Node

signal attacker_hits(event, attacker, defender)
signal attacker_misses(event, attacker, defender)
signal defender_hits(event, attacker, defender)
signal defender_misses(event, attacker, defender)

signal unit_moved(event, unit)
signal unit_move_finished(unit)

signal turn_refresh(event, side)
signal turn_end(event, side)

var UNIT_ID = 0
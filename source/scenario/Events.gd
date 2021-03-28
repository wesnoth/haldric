class_name Events

signal start(scenario)
signal unit_moved(loc)

signal attack(attacker, defender)

signal attacker_hit(attacker, defender)
signal attacker_missed(attacker, defender)
signal defender_hit(attacker, defender)
signal defender_missed(attacker, defender)

signal combat_finished()


func trigger_event(event: String, args := []) -> void:
	args.push_front(event)
	callv("emit_signal", args)

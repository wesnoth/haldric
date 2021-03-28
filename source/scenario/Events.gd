class_name Events

signal start(scenario)
signal unit_moved(loc)
signal combat_finished()


func trigger_event(event: String, args := []) -> void:
	args.push_front(event)
	callv("emit_signal", args)

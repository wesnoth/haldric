class_name Events

signal prestart()
signal start()
signal unit_moved(loc)
signal combat_finished()
signal turn_end()
signal victory()

func trigger_event(event: String, args: Array) -> void:
	args.push_front(event)
	callv("emit_signal", args)

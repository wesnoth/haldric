class_name Command

enum Mode { EXECUTE, REVERT }

signal finished()
signal started()

signal trigger_event_called(name, args)

var mode := 0
var is_revertable := false


func execute() -> void:
	emit_signal("started")

	match mode:
		Mode.EXECUTE:
			_execute()
		Mode.REVERT:
			_revert()
			_execute()


func trigger_event(event: String, args := []) -> void:
	emit_signal("trigger_event_called", event, args)


func _finished() -> void:
	emit_signal("finished")


func _execute() -> void:
	assert(false)


func _revert() -> void:
	assert(false)



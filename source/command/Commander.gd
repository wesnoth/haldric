extends Node
class_name Commander

signal command_started()
signal command_finished()

signal command_trigger_event_called(signal_name, args)

var _history := []
var _todo := []
var _done := []

var _active_command : Command = null


func _ready() -> void:
	_history = []
	_todo = []
	_done = []


func _process(delta: float) -> void:
	if not _todo or _active_command:
		return

	_execute_next_command()


func queue(command: Command) -> void:
	command.connect("started", self, "_on_command_started")
	command.connect("finished", self, "_on_command_finished")
	command.connect("trigger_event_called", self, "_on_command_trigger_event_called")
	_todo.append(command)


func undo() -> void:
	if not _done:
		return

	_todo.append(_done.pop_front())


func _execute_next_command() -> void:
	_active_command = _todo.pop_front()
	_active_command.execute()


func _on_command_started() -> void:
	emit_signal("command_started")


func _on_command_finished() -> void:
	_history.append(_active_command)

	if not _active_command.is_revertable:
		_done.clear()

	elif _active_command.mode == Command.Mode.EXECUTE:
		_active_command.mode = Command.Mode.REVERT
		_done.push_front(_active_command)

	_active_command = null

	emit_signal("command_finished")

	if _todo:
		_execute_next_command()


func _on_command_trigger_event_called(signal_name: String, args: Array) -> void:
	emit_signal("command_trigger_event_called", signal_name, args)

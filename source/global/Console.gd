extends CanvasLayer

onready var console := $MarginContainer/VBoxContainer/TextEdit as Label
onready var edit := $MarginContainer/VBoxContainer/Line/LineEdit as LineEdit

var lines = []

func _ready() -> void:
	edit.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_released("message") and not edit.has_focus():
		edit.grab_focus()
		edit.show()


func write(text: String) -> void:
	_add_line(text)
	console.text = _get_lines()


func warn(text: String) -> void:
	write("! " + text)


func _add_line(text: String) -> void:
	lines.append(text)

	if lines.size() > 12:
		lines.pop_front()


func _get_lines() -> String:
	var s := ""
	for line in lines:
		s += line + "\n"
	return s


func _execute_command(command_line: String) -> void:
	command_line = command_line.strip_edges()
	write(">>> " + command_line)
	var array := command_line.split(" ")
	var command = array[0]
	array.remove(0)

	ConsoleCommands.callv(command, array)


func _on_LineEdit_text_entered(new_text: String) -> void:
	if new_text.begins_with("/"):
		new_text.erase(0, 1)
		_execute_command(new_text)
	else:
		write("> " + new_text)
	edit.hide()
	edit.clear()
	edit.release_focus()

extends Control
class_name InfoDialogue

onready var panel := $Panel
onready var character_name := $Panel/VBoxContainer/CharacterName
onready var info_text := $Panel/VBoxContainer/InfoText

var queue = []

func show_text(char_name, text):
	if visible:
		queue.push_back([char_name, text])
		return
	show()
	character_name.text = char_name
	info_text.text = text

func _input(event):
	if event is InputEventMouseButton && event.is_action_released("LMB") && visible:
		hide()
		if queue:
			var dat = queue.pop_front()
			show_text(dat[0], dat[1])
		get_tree().set_input_as_handled()

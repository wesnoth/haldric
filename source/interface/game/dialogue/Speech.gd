extends Control
class_name Speech

signal finished()

export var speaker := ""
export var portrait : Texture = null
export var flip_portrait := false
export(Array, String, MULTILINE) var lines = []
export var fadout_time := 0.5
export var fadin_time := 1.0
export var start_delay := 0.0

var current = -1 setget _set_current

onready var portrait_rect: TextureRect = $Portrait
onready var text_box: TextBox = $TextBox
onready var name_label := $TextBox/Panel/MarginContainer/Name


static func instance() -> Speech:
	return load("res://source/interface/game/dialogue/Speech.tscn").instance() as Speech


func _ready() -> void:
	visible = false
	name_label.text = speaker
	portrait_rect.texture = portrait
	portrait_rect.flip_h = flip_portrait
	text_box.speaker = speaker


func start():
	visible = true
	if has_next_line():
		next_line()
	else:
		finish()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if has_next_line() and not is_writing():
			next_line()
		elif is_writing():
			complete()
		elif not has_next_line() and not is_writing():
			finish()


func reset():
	current = -1
	text_box.reset()


func next_line():
	self.current += 1


func has_next_line():
	return current + 1 < lines.size()


func complete():
	text_box.complete()


func finish() -> void:
	modulate.a = 0
	emit_signal("finished")


func is_writing():
	return text_box.writing


func _set_current(value):
	current = value
	text_box.write(lines[current])

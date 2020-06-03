extends Control
class_name PopupLabel

var font_size := 16
var text := ""
var time := 0.5
var distance := 150
var color := Color("FFFFFF")

onready var label := $Label
onready var tween := $Tween


static func instance() -> PopupLabel:
	return load("res://source/interface/misc/PopupLabel.tscn").instance() as PopupLabel


func _ready() -> void:
	label.set("custom_fonts/font", label.get("custom_fonts/font").duplicate())
	label.get("custom_fonts/font").set_size(font_size)
	label.modulate = color
	label.text = text
	_animate()


func _animate():
	rect_scale = Vector2(0, 0)
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1, 1), time, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(self, "rect_global_position:y", rect_global_position.y, rect_global_position.y - distance, time, Tween.TRANS_SINE, Tween.EASE_IN, time)
	tween.interpolate_property(self, "modulate:a", 1, 0, time, Tween.TRANS_SINE, Tween.EASE_IN, time)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	queue_free()

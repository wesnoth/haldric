extends Control

export(String) var stat = "HP"
export(Color) var color = Color("ffffffff")
onready var value_label = $"HBox/Value"
onready var stat_label = $"HBox/Stat"

func _ready():
	stat_label.text = str(stat)
	value_label.self_modulate = color

func set_value(value):
	value_label.text = str(value)

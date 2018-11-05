extends Control

export(String) var stat = "HP"

onready var value_label = $"HBox/Value"
onready var stat_label = $"HBox/Stat"

func _ready():
	stat_label.text = str(stat)

func set_value(value):
	value_label.text = str(value)

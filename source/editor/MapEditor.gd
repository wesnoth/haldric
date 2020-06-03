extends Node2D

func _ready() -> void:
	var map := Map.instance()
	map.initialize(preload("res://data/maps/map.tres"))
	add_child(map)

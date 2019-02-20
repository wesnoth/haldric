extends Node2D

var map : Map

func _ready():
	_initialize()

func _initialize():
	map = Loader.load_map(Registry.scenarios["scenario"].map_data)
	add_child(map)
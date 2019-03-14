extends Node2D

var map : Map

onready var map_container = $MapContainer
onready var unit_container = $UnitContainer

func _ready():
	_initialize()

func _initialize():
	map = Loader.load_map(Registry.scenarios["scenario"].map_data)
	map_container.add_child(map)
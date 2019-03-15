extends Node2D

var map : Map

onready var map_container = $MapContainer
onready var unit_container = $UnitContainer

func _ready():
	_load_map()
	_load_units()

func _load_map():
	map = Loader.load_map(Registry.scenarios["scenario"].map_data)
	map_container.add_child(map)

func _load_units():
	var unit = Unit.new(Registry.units["Archer"])
	add_child(unit)
	unit.move_to(map.get_location(Vector2(4, 4)))

func _on_SaveMap_pressed():
	Loader.save_map(map)

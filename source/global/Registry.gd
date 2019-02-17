extends Node

var units := {}

func _ready() -> void:
	_setup_units()

func _setup_units() -> void:
	
	units = Loader.load_yaml_dir("res://data/units")
	
	for unit in units.values():
		if unit.has("abilities"):
			unit.abilities = []
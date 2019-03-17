extends Node2D

var scenario = null

onready var scenario_container = $ScenarioContainer

func _ready():
	_load_map()
	_load_units()

func _load_map() -> void:
	if Global.scenario_name:
		scenario = load(Registry.scenarios[Global.scenario_name]).instance()
		scenario_container.add_child(scenario)

func _load_units() -> void:
	var unit = Unit.new(Registry.units["Archer"])
	scenario.add_unit(unit, Vector2(4, 4))

func _on_SaveMap_pressed() -> void:
	Loader.save_map(scenario.map)

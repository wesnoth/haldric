extends Node2D

var scenario : Scenario = null

onready var scenario_container = $ScenarioContainer

func _ready():
	_load_map()
	_load_units()

func _load_map() -> void:
	if Registry.scenarios.has(Global.scenario_name):
		scenario = load(Registry.scenarios[Global.scenario_name]).instance()
		scenario_container.add_child(scenario)
		scenario.initialize()

func _load_units() -> void:
	if scenario:
		var unit = Unit.new(Registry.units["Archer"])
		scenario.add_unit(unit, Vector2(4, 4),2)

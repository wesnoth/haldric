extends Node2D

var scenario = null

onready var scenario_container = $ScenarioContainer
onready var unit_container = $UnitContainer

func _ready():
	_load_map()
	_load_units()

func _load_map() -> void:
	scenario = load(Registry.scenarios["test"]).instance()
	scenario_container.add_child(scenario)

func _load_units() -> void:
	var unit = Unit.new(Registry.units["Archer"])
	scenario.add_unit(unit, Vector2(4, 4))

func _on_SaveMap_pressed() -> void:
	Loader.save_map(scenario.map)

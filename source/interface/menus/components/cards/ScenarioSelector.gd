extends CardSelector
class_name ScenarioSelector

const ScenarioCard = preload("res://source/interface/menus/components/cards/ScenarioCard.tscn")

func _ready() -> void:
	for scenario in Registry.scenarios:
		#print(scenario)
		_add_scenario(scenario)

func _add_scenario(scenario) -> void:
	var file_data = Registry.scenarios[scenario]
	var button = ScenarioCard.instance()
	button.connect("pressed", self, "_on_scenario_card_pressed", [scenario])
	card_container.add_child(button)
	button.initialize(file_data.data)

func _on_scenario_card_pressed(id):
	Global.scenario_name = id
	Scene.change(Scene.Game)

extends CardSelector
class_name ScenarioSelector

const ScenarioCard = preload("res://source/interface/menus/components/cards/ScenarioCard.tscn")

func _ready() -> void:
	for scenario in Registry.scenarios:
		_add_scenario(scenario)

func _add_scenario(scenario: String) -> void:
	var file_data = Registry.scenarios[scenario]
	var card = ScenarioCard.instance()
	card.connect("pressed", self, "_on_scenario_card_pressed", [card, scenario])
	card_container.add_child(card)
	card.initialize(file_data.data)

func _on_scenario_card_pressed(card: MenuCard, id: String) -> void:
	._on_card_pressed(card, id)

	Global.state.scenario_name = id
	Scene.change(Scene.Game)

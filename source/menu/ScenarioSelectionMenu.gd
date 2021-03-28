extends Panel

onready var buttons := $CenterContainer/VBoxContainer


func _ready() -> void:
	for key in Data.scenarios:
		var scenario : ScenarioData = Data.scenarios[key]
		if scenario.show:
			var button = Button.new()
			button.rect_min_size = Vector2(200, 60)
			button.connect("pressed", self, "_on_Scenario_selected", [ scenario ])
			button.text = scenario.alias
			buttons.add_child(button)


func _on_Scenario_selected(scenario: ScenarioData) -> void:
	Campaign.selected_scenario = scenario
	Campaign.recall_list = {}
	if (scenario.type == ScenarioData.ScenarioType.CAMPAIGN):
		Scene.change("Game")
	else:
		Scene.change("FactionSelectionMenu")

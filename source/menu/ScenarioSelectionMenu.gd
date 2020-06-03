extends Control

onready var buttons := $CenterContainer/VBoxContainer


func _ready() -> void:
	for key in Data.scenarios:
		var scenario : ScenarioData = Data.scenarios[key]

		var button = Button.new()
		button.connect("pressed", self, "_on_Scenario_selected", [ scenario ])
		button.text = scenario.alias
		buttons.add_child(button)

func _on_Scenario_selected(scenario: ScenarioData) -> void:
	Global.selected_scenario = scenario
	Scene.change("Game", true, true)

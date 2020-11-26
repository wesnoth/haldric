extends Panel

onready var buttons := $CenterContainer/VBoxContainer


func _ready() -> void:
	for key in Data.scenarios:
		var scenario : ScenarioData = Data.scenarios[key]

		var button = Button.new()
		button.rect_min_size = Vector2(200, 60)
		button.connect("pressed", self, "_on_Scenario_selected", [ scenario ])
		button.text = scenario.alias
		buttons.add_child(button)


func _on_Scenario_selected(scenario: ScenarioData) -> void:
	Global.selected_scenario = scenario
	Scene.change("FactionSelectionMenu")

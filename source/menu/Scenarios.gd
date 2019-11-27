extends Panel

onready var scenario_line := $CenterContainer/VBoxContainer/HBoxContainer/LineEdit

func _on_Play_pressed() -> void:
	var scenario = scenario_line.text

	if not Registry.scenarios.has(scenario):
		print("Failed to load Scenario: %s" % scenario)
		return

	Global.state.scenario = Registry.scenarios[scenario]
	Scene.change("Game")

func _on_Back_pressed() -> void:
	Scene.change("TitleScreen")

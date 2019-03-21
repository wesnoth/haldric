extends Control

onready var option_button := $CenterContainer/VBoxContainer/OptionButton as OptionButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_Play_pressed()

func _ready() -> void:
	var i := 0
	for scenario in Registry.scenarios:

		if Registry.scenarios[scenario].data.title != "":
			option_button.add_item(Registry.scenarios[scenario].data.title, i)
		else:
			option_button.add_item(scenario, i)

		option_button.set_item_metadata(i, scenario)
		i += 1

func _on_Back_pressed() -> void:
	Scene.change(Scene.TitleScreen)

func _on_Play_pressed() -> void:
	var scenario: String = option_button.get_selected_metadata()

	Global.scenario_name = scenario
	Scene.change(Scene.Game)

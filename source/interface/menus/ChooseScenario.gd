extends Control

onready var option_button = $CenterContainer/VBoxContainer/OptionButton

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Play_pressed()

func _ready():
	var i = 0
	for scenario in Registry.scenarios.keys():
		option_button.add_item(scenario, i)
		option_button.set_item_metadata(i, scenario)
		i += 1

func _on_Back_pressed():
	Scene.change(Scene.TitleScreen)

func _on_Play_pressed():
	var scenario = option_button.get_selected_metadata()

	Global.scenario_name = scenario
	Scene.change(Scene.Game)

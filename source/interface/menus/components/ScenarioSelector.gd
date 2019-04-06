extends ScrollContainer
class_name ScenarioSelector

const ScenarioCard = preload("res://source/interface/menus/components/ScenarioCard.tscn")

onready var grid_container = $CenterContainer/GridContainer
onready var scenario_cards = grid_container.get_children()

func _ready() -> void:
	for scenario in Registry.scenarios:
		print(scenario)
		_add_scenario(scenario)

func animate():
	_hide_all_cards()
	for child in scenario_cards:
		child.animate()
		yield(get_tree().create_timer(0.1), "timeout")

func _hide_all_cards() -> void:
	for child in scenario_cards:
		child.modulate = Color("00FFFFFF")

func _add_scenario(scenario) -> void:
	var file_data = Registry.scenarios[scenario]
	var button = ScenarioCard.instance()
	button.connect("pressed", self, "_on_scenario_card_pressed", [scenario])
	grid_container.add_child(button)
	button.initialize(file_data.data.title)

func _on_scenario_card_pressed(id):
	Global.scenario_name = id
	Scene.change(Scene.Game)
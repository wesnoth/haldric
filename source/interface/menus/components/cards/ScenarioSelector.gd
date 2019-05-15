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
	if card.expanded:
		card.shrink()
		_on_shrink(card)
	else:
		card.expand(Rect2(rect_global_position, rect_size))
		_on_expand(card)
	
	Global.scenario_name = id
	Scene.change(Scene.Game)

func _on_shrink(selected_card: MenuCard) -> void:
	for card in card_container.get_children():
		if card != selected_card:
			card.animate()
			card.show()

func _on_expand(selected_card: MenuCard) -> void:
	for card in card_container.get_children():
		if card != selected_card:
			card.hide()
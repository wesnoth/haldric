extends MenuPage

onready var scenario_selector = $ScenarioSelector

func _enter() -> void:
	scenario_selector.animate()


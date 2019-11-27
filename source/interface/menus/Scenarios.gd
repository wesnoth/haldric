extends MenuPage

onready var scenario_selector = $ScenarioSelector

func _enter() -> void:
	scenario_selector.animate()

func _on_MapEditor_pressed():
	Scene.change(Scene.Editor)

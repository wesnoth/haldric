extends CanvasLayer

onready var unit_panel = $UnitPanel as Control
onready var side_panel = $SidePanel as Control

func update_unit_info(unit : Unit) -> void:
	unit_panel.update_unit(unit)

func update_side_info(scenario : Scenario, side : Side) -> void:
	side_panel.update_side(scenario, side)

func clear_unit_info() -> void:
	unit_panel.clear_unit()

func _on_Back_pressed() -> void:
	Scene.change(Scene.TitleScreen)

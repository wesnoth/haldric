extends CanvasLayer

signal turn_end_pressed

onready var unit_panel := $UnitPanel as Control
onready var side_panel := $SidePanel as Control
onready var tod_panel := $ToDPanel as Control

onready var pause_menu := $PauseMenu as Control

func update_time_info(time: Time) -> void:
	if not time:
		return
	tod_panel.update_time(time)

func update_unit_info(unit : Unit) -> void:
	unit_panel.update_unit(unit)

func update_side_info(scenario : Scenario, side : Side) -> void:
	side_panel.update_side(scenario, side)

func clear_unit_info() -> void:
	unit_panel.clear_unit()

func is_pause_active() -> bool:
	return pause_menu.is_active()

func _on_Back_pressed() -> void:
	Scene.change(Scene.TitleScreen)

func _on_TurnEndPanel_turn_end_pressed() -> void:
	emit_signal("turn_end_pressed")

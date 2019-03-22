extends CanvasLayer

onready var unit_info = $UnitPanel

func update_unit_info(unit : Unit) -> void:
	unit_info.update_unit(unit)

func clear_unit_info() -> void:
	unit_info.clear_unit()

func _on_Back_pressed() -> void:
	Scene.change(Scene.TitleScreen)

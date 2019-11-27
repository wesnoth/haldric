extends CanvasLayer

onready var unit_plate_container := $UnitPlateContainer as Control

func add_unit_plate(unit_plate) -> void:
	unit_plate_container.add_child(unit_plate)

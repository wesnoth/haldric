extends CanvasLayer
const UnitPlate = preload("res://source/interface/hud/UnitPlate.tscn")
onready var unit_plate_container := $UnitPlateContainer as Control

var unit_plates := {}

func add_unit_plate(unit: Unit) -> void:
	var unit_plate = UnitPlate.instance() as UnitPlate
	unit_plate_container.add_child(unit_plate)
	unit_plate.init(unit)
	unit.attach_ui(unit_plate)
	unit_plates[unit.get_instance_id()] = unit_plate

func remove_unit_plate(unit: Unit) -> void:
	var plate_to_remove = unit_plates[unit.get_instance_id()]
	unit_plates.erase(unit.get_instance_id())
	unit_plate_container.remove_child(plate_to_remove)

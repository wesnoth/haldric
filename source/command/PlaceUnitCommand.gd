extends Command
class_name PlaceUnitCommand

var _unit: Unit = null
var _target_loc: Location = null


func _init(unit: Unit, target_loc: Location) -> void:
	_unit = unit
	_target_loc = target_loc


func _execute() -> void:

	_unit.position = _target_loc.position

	_target_loc.unit = _unit

	print("unit placed on ", _target_loc.cell)
	trigger_event("unit_moved", [_target_loc])
	_finished()

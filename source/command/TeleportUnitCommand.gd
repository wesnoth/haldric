extends Command
class_name TeleportUnitCommand

var _start_loc: Location = null
var _end_loc: Location = null
var _side: Side = null


func _init(side: Side, start_loc: Location, end_loc: Location) -> void:
	is_revertable = true

	_side = side
	_start_loc = start_loc
	_end_loc = end_loc


func _execute() -> void:
	_side.remove_castle(_start_loc)

	var unit = _start_loc.unit

	unit.position = _end_loc.position

	_end_loc.unit = unit
	_start_loc.unit = null

	print("teleport from ", _start_loc.cell, " to ", _end_loc.cell)
	trigger_event("unit_moved", [_end_loc])
	_finished()


func _revert() -> void:
	var loc = _start_loc
	_start_loc = _end_loc
	_end_loc = loc

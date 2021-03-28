extends Command
class_name MoveUnitCommand

var _start_loc: Location = null
var _side: Side = null
var _path: Array = []


func _init(side: Side, start_loc: Location, path: Array) -> void:
	is_revertable = true

	_side = side
	_start_loc = start_loc
	_path = path


func _execute() -> void:
	_side.remove_castle(_start_loc)

	var mover := Mover.new()
	Global.get_tree().current_scene.add_child(mover)
	mover.connect("finished", self, "_on_mover_finished")

	mover.start(_start_loc, _path.duplicate())


func _revert() -> void:
	_path.invert()
	_path.append(_start_loc)
	_start_loc = _path.pop_front()


func _on_mover_finished(end_loc: Location) -> void:
	print("moved from ", _start_loc.cell, " to ", end_loc.cell)
	trigger_event("unit_moved", [end_loc])
	_finished()

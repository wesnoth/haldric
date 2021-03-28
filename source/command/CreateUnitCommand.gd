extends Command
class_name CreateUnitCommand

var _parent: Node = null
var _loc: Location = null
var _side: Side = null
var _alias := ""
var _is_leader := false


func _init(parent: Node, alias: String, side: Side, loc: Location, is_leader := false) -> void:
	_parent = parent
	_alias = alias
	_loc = loc
	_side = side
	_is_leader = is_leader


func _execute() -> void:
	var unit : Unit = Unit.instance()
	var type: UnitType = Data.units[_alias].instance()

	_loc.unit = unit

	unit.type = type
	unit.is_leader = _is_leader
	unit.side_number = _side.number
	unit.side_color = _side.color
	unit.team_name = _side.team_name

	_parent.add_child(unit)
	unit.global_position = _loc.position

	unit.new_traits()
	unit.apply_traits()
	unit.restore()

	_side.add_unit(unit, _is_leader)

	Global.get_tree().call_group("GameUI", "add_unit_plate", unit)

	trigger_event("unit_moved", [_loc])
	_finished()

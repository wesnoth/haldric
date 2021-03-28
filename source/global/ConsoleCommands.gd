extends Node

var scenario : Scenario = null


func add_unit(side_number: String, unit_type: String, is_leader := "false") -> void:
	if not scenario or not scenario.hovered_location:
		return

	scenario.create_unit(int(side_number), unit_type, scenario.hovered_location.cell.x, scenario.hovered_location.cell.y, bool(is_leader))


func add_gold(side_number: String, amount: String) -> void:
	if not scenario:
		return

	var side = scenario.sides.get_child(int(side_number) - 1)

	side.gold += int(amount)

	if side == scenario.current_side:
		get_tree().call_group("SideUI", "update_info", side)

func advance() -> void:
	if not scenario or not scenario.hovered_location or not scenario.hovered_location.unit:
		return

	var unit := scenario.hovered_location.unit
	unit.grant_experience(unit.experience.get_difference())


func grant_experience(amount: String) -> void:
	if not scenario or not scenario.hovered_location or not scenario.hovered_location.unit:
		return

	scenario.hovered_location.unit.grant_experience(int(amount))


func hurt(damage: String) -> void:
	if not scenario or not scenario.hovered_location or not scenario.hovered_location.unit:
		return

	scenario.hovered_location.unit.hurt(int(damage))


func heal(amount: String) -> void:
	if not scenario or not scenario.hovered_location or not scenario.hovered_location.unit:
		return

	scenario.hovered_location.unit.heal(int(amount))


func kill() -> void:
	if not scenario or not scenario.hovered_location or not scenario.hovered_location.unit:
		return

	scenario.hovered_location.unit.kill()


func end_turn() -> void:
	if not scenario:
		return

	scenario.end_turn()

extends Node

var scenario : Scenario = null


func add_unit(side_number: String, unit_type: String, x: String, y: String, is_leader := "false") -> void:
	if not scenario:
		return

	scenario.add_unit(int(side_number), unit_type, int(x), int(y), bool(is_leader))


func add_gold(side_number: String, amount: String) -> void:
	if not scenario:
		return

	var side = scenario.sides[int(side_number)]

	side.gold += int(amount)

	if side == scenario.current_side:
		get_tree().call_group("SideUI", "update_info", side)


func advance(unit_type_id: String, property: String, value := "") -> void:
	if not scenario:
		return

	if not Data.units.has(unit_type_id):
		Console.warn(unit_type_id + " does not exist!")
		return

	for unit in scenario.find_units(property, str2var(value)):
		unit.advance(Data.units[unit_type_id].instance())


func hurt(damage: String, property: String, value := "") -> void:
	if not scenario:
		return

	for unit in scenario.find_units(property, str2var(value)):
		unit.hurt(int(damage))


func heal(amount: String, property: String, value := "") -> void:
	if not scenario:
		return

	for unit in scenario.find_units(property, str2var(value)):
		unit.heal(int(amount))


func kill(property: String, value := "") -> void:
	if not scenario:
		return

	for unit in scenario.find_units(property, str2var(value)):
		unit.kill()


func end_turn() -> void:
	if not scenario:
		return

	scenario.end_turn()


func new_attack() -> void:
	if not scenario:
		return

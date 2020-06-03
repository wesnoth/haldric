extends Node
class_name Side

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

var number := 0

var income := 0
var upkeep := 0

var leaders := []
var units := []
var villages := []

export var start_position := Vector2()

export var gold := 100
export var base_income := 2

export var color := Color.pink

export var leader := ""
export(Array, String) var random_leader := []
export(Array, String) var recruit := []


func _ready() -> void:
	number = get_index()
	update_income()


func turn_refresh() -> void:
	gold += income - upkeep
	for unit in units:
		unit.refresh()


func turn_end() -> void:
	for unit in units:
		unit.turn_end()


func update_income() -> void:
	_calculate_upkeep()
	_calculate_income()


func add_unit(unit: Unit, is_leader := false) -> void:
	units.append(unit)

	if is_leader:
		leaders.append(unit)

	unit.connect("died", self, "_on_unit_died")

	update_income()


func add_village(loc: Location) -> void:
	loc.side_number = number
	villages.append(loc)

	update_income()
	Console.write("added village to side %d" % number)


func remove_village(loc: Location) -> void:
	if not villages.has(loc):
		return

	villages.erase(loc)
	update_income()
	Console.write("removed village from side %d" % number)


func has_village(loc: Location) -> bool:
	return villages.has(loc)


func can_recruit() -> bool:
	return has_leader_in_village() and find_recruit_location() != null


func has_leader_in_village() -> bool:
	for village in villages:
		if leaders.has(village.unit):
			return true
	Console.warn("side %d cannot recruit (no leader in village)" % (number + 1))
	return false


func find_recruit_location() -> Location:
	for village in villages:
		if not leaders.has(village.unit):
			continue

		for loc in village.village:
			if not loc.unit:
				return loc
	Console.warn("side %d cannot recruit (no free space in village)" % (number + 1))
	return null


func is_unit_leader(unit: Unit) -> bool:
	return leaders.has(unit)


func _calculate_upkeep() -> void:
	upkeep = 0

	for unit in units:
		upkeep += unit.type.level


func _calculate_income() -> void:
	var village_income := 0

	for loc in villages:
		village_income += loc.village.size()

	income = base_income + village_income
	print("village income: ", village_income)


func _on_unit_died(unit : Unit) -> void:
	var idx = leaders.find(unit)

	if idx >= 0:
		leaders.remove(idx)

	units.erase(unit)

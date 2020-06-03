extends Node
class_name Side

const HEAL_ON_TOWN = 8
const HEAL_ON_REST = 2

var number := 0

var income := 0
var upkeep := 0

var leaders := []
var units := []
var towns := []

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


func add_town(loc: Location) -> void:
	loc.side_number = number
	towns.append(loc)

	update_income()
	Console.write("added town to side %d" % number)


func remove_town(loc: Location) -> void:
	if not towns.has(loc):
		return

	towns.erase(loc)
	update_income()
	Console.write("removed town from side %d" % number)


func has_town(loc: Location) -> bool:
	return towns.has(loc)


func can_recruit() -> bool:
	return has_leader_in_town() and find_recruit_location() != null


func has_leader_in_town() -> bool:
	for town in towns:
		if leaders.has(town.unit):
			return true
	Console.warn("side %d cannot recruit (no leader in town)" % (number + 1))
	return false


func find_recruit_location() -> Location:
	for town in towns:
		if not leaders.has(town.unit):
			continue

		for loc in town.town:
			if not loc.unit:
				return loc
	Console.warn("side %d cannot recruit (no free space in town)" % (number + 1))
	return null


func is_unit_leader(unit: Unit) -> bool:
	return leaders.has(unit)


func _calculate_upkeep() -> void:
	upkeep = 0

	for unit in units:
		upkeep += unit.type.level


func _calculate_income() -> void:
	var town_income := 0

	for loc in towns:
		town_income += loc.town.size()

	income = base_income + town_income
	print("town income: ", town_income)


func _on_unit_died(unit : Unit) -> void:
	var idx = leaders.find(unit)

	if idx >= 0:
		leaders.remove(idx)

	units.erase(unit)

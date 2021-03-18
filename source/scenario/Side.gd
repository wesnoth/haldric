extends Node
class_name Side

signal unit_added()
signal unit_removed()

enum Controller { HUMAN, AI }

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

const VILLAGE_INCOME = 2


var income := 0
var upkeep := 0

var leaders := []
var units := []
var villages := []
var castles := []

export(Controller) var controller : int = Controller.HUMAN

export var number := 0
export var start_position := Vector2()

export var gold := 100
export var base_income := 2

export var color := Color.pink

export var ai := "SimpleAI"

export var leader := ""

export(Array, String) var random_leader := []
export(Array, String) var recruit := []

export(Array, Dictionary) var recall := []

export var team_name := ""


func _ready() -> void:
	if not number:
		number = get_index() + 1

	if not team_name:
		team_name = str(number)
	recall = get_recall_list()
	update_income()


func set_faction(data: FactionData) -> void:
	var random_leaders := data.random_leader.duplicate()

	if random_leaders:
		random_leaders.shuffle()
		leader = random_leaders[0]

	recruit = data.recruit


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
	emit_signal("unit_added", unit)

	update_income()


func add_village(loc: Location) -> void:
	loc.side_number = number
	loc.team_name = team_name
	villages.append(loc)

	update_income()
	Console.write("added village to side %d" % number)


func add_castle(loc: Location) -> void:
	castles.append(loc)
	Console.write("added castle to side %d" % number)


func remove_castle(loc: Location) -> void:
	if not castles.has(loc):
		return

	castles.erase(loc)
	Console.write("castle village from side %d" % number)


func remove_village(loc: Location) -> void:
	if not villages.has(loc):
		return

	villages.erase(loc)
	update_income()
	Console.write("removed village from side %d" % number)


func has_village(loc: Location) -> bool:
	return villages.has(loc)


func has_castle(loc: Location) -> bool:
	return castles.has(loc)

func has_castle_loc(loc: Location) -> bool:
	for keep in castles:
		for castle in keep.castle:
			if castle == loc:
				return true
	return false

func can_recruit() -> bool:
	return is_leader_on_keep() and find_recruit_location() != null


func is_leader_on_keep() -> bool:
	if castles:
		return true
	Console.warn("side %d cannot recruit (no leader in keep)" % (number + 1))
	return false


func find_recruit_location() -> Location:
	for castle in castles:
		if not leaders.has(castle.unit):
			continue

		for loc in castle.castle:
			if not loc.unit:
				return loc
	Console.warn("side %d cannot recruit (no free space in castle)" % (number + 1))
	return null


func is_unit_leader(unit: Unit) -> bool:
	return leaders.has(unit)

func get_recall_list() -> Array:
#	var ret := []
#	ret.append({"id":"Bowman","level":1,"xp":7,"traits":["Quick","Dextrous"]})
#	ret.append({"id":"Spearman","level":1,"xp":22,"traits":["Loyal","Strong"]})
	if controller == Controller.HUMAN:
		return Global.recall_list
	else:
		return []

func write_recall_list() -> void:
	if controller == Controller.AI:
		return

	for unit in units:
		var data = {"id": unit.type.alias, "level": unit.type.level, 
			"xp": unit.experience.value, "traits": []}
		for trait in unit.traits.get_children():
			data.traits.append(trait.alias)
		Global.recall_list.append(data)

func _calculate_upkeep() -> void:
	upkeep = 0

	for unit in units:
		upkeep += unit.get_upkeep()

	upkeep = clamp(upkeep - villages.size(), 0, upkeep)


func _calculate_income() -> void:
	income = villages.size() * VILLAGE_INCOME + base_income


func _on_unit_died(unit: Unit) -> void:
	var idx = leaders.find(unit)

	if idx >= 0:
		leaders.remove(idx)

	units.erase(unit)

	emit_signal("unit_removed", unit)

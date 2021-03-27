tool
extends Node2D
class_name Scenario

signal location_hovered(loc)
signal unit_move_finished(loc)
signal combat_finished()

signal show_info_dialogue(char_name, text)

const FLAG_OFFSET = Vector2(15, 25)

var map_data : MapData = null

var map : Map = null

var hovered_location : Location = null

var current_side : Side = null

var flags := {}
var AIs := {}

var is_side_moving := false

onready var schedule = $Schedule
onready var sides = $Sides

onready var map_container := Node2D.new()
onready var flag_container := YSort.new()
onready var unit_container := YSort.new()

export (String) var next_scenario := ""

var turn_num := 0


func _ready() -> void:
	if Engine.editor_hint:
		return

	_setup()
	_load_map()
	_load_sides()

	EventBus.raise_event("start", {"scenario": self})


func _enter_tree() -> void:
	if not Engine.editor_hint:
		return

	if not $Schedule:
		schedule = Schedule.new()
		schedule.name = "Schedule"
		add_child(schedule)
		schedule.owner = get_tree().edited_scene_root
		print("Node added: %s" % schedule.name)

	if not $Sides:
		sides = Node.new()
		sides.name = "Sides"
		add_child(sides)
		sides.owner = get_tree().edited_scene_root
		print("Node added: %s" % sides.name)


func _get_configuration_warning() -> String:
	var warning := ""

	if name == "UnitType":
		warning += "rename root!\n"

	if not $Schedule:
		warning += "Schedule Node missing!\n"

	if $Schedule.get_child_count() == 0:
		warning += "No ToD defined!\n"

	if not $Sides:
		warning += "Side Node missing!\n"

	if $Sides.get_child_count() == 0:
		warning += "No Side Node defined!\n"

	return warning

func show_info_dialogue(char_name, text):
	emit_signal("show_info_dialogue", char_name, text)


func recruit(unit_type_id: String, loc: Location = null) -> void:
	if loc == null:
		loc = current_side.find_recruit_location()

	if not loc:
		Console.warn("No recruit location found for side %d" % current_side.number)
		return

	var unit_type: UnitType = Data.units[unit_type_id].instance()

	if unit_type == null:
		Console.warn("Invalid unit type '%s'" % unit_type_id)
		return

	if current_side.gold < unit_type.cost:
		Console.warn("Side %d has not enough Gold!" % current_side.number)
		return

	current_side.gold -= unit_type.cost
	current_side.update_income()

	var unit = Unit.instance()

	EventBus.raise_event("prerecruit", {"scenario": self, "side": current_side, "unit": unit, "loc": loc})

	unit.side_number = current_side.number
	unit.side_color = current_side.color
	unit.team_name = current_side.team_name
	unit.type = unit_type

	current_side.add_unit(unit)

	unit_container.add_child(unit)
	get_tree().call_group("GameUI", "add_unit_plate", unit)

	unit.new_traits()
	unit.apply_traits()
	unit.restore()

	place_unit(unit, loc)
	unit.suspend()

	get_tree().call_group("SideUI", "update_info", current_side)

	EventBus.raise_event("recruit", {"scenario": self, "side": current_side, "unit": unit, "loc": loc})


func recall(unit_type_id: String, data: Dictionary, loc: Location = null) -> void:
	if loc == null:
		loc = current_side.find_recruit_location()

	if not loc:
		Console.warn("No recruit location found for side %d" % current_side.number)
		return

	var unit_type: UnitType = Data.units[unit_type_id].instance()

	if unit_type == null:
		Console.warn("Invalid unit type '%s'" % unit_type_id)
		return

	if current_side.gold < 20:
		Console.warn("Side %d has not enough Gold!" % current_side.number)
		return

	current_side.gold -= 20
	current_side.update_income()

	var unit = Unit.instance()

	EventBus.raise_event("prerecall", {"scenario": self, "side": current_side, "unit": unit, "loc": loc})

	unit.side_number = current_side.number
	unit.side_color = current_side.color
	unit.team_name = current_side.team_name
	unit.type = unit_type

	current_side.add_unit(unit)

	unit_container.add_child(unit)
	get_tree().call_group("GameUI", "add_unit_plate", unit)

	for trait in data["traits"]:
		var trait_obj = load("res://data/traits/%s.tscn" % trait).instance()
		unit.traits.add_child(trait_obj)
	unit.apply_traits()
	unit.experience.value = data["xp"]
	unit.health.fill()

	place_unit(unit, loc)
	unit.suspend()

	get_tree().call_group("SideUI", "update_info", current_side)
	current_side.recall.erase(data)

	EventBus.raise_event("recall", {"scenario": self, "side": current_side, "unit": unit, loc: "loc"})


func add_unit(side_number: int, unit_type_id: String, x: int, y: int, is_leader := false) -> void:

	if not Data.units.has(unit_type_id):
		Console.warn("Invalid unit type '%s'" % unit_type_id)
		return

	var unit_type: UnitType = Data.units[unit_type_id].instance()
	var side : Side = get_side(side_number)
	var unit = Unit.instance()

	unit.is_leader = is_leader
	unit.side_number = side.number
	unit.side_color = side.color
	unit.team_name = side.team_name
	unit.type = unit_type

	side.add_unit(unit, is_leader)
	unit_container.add_child(unit)

	unit.new_traits()
	unit.apply_traits()
	unit.restore()

	get_tree().call_group("GameUI", "add_unit_plate", unit)

	var loc = map.get_location_from_cell(Vector2(x, y))
	place_unit(unit, loc)

	EventBus.raise_event("add_unit", {"scenario": self, "side": get_side(side_number), "unit": unit, "loc": loc, "is_leader": is_leader})
	# NOTE: Currently only called in _load_sides


func place_unit(unit: Unit, target_loc: Location) -> void:

	if not target_loc:
		Console.warn("invalid coordinates, cannot place unit")
		return

	unit.global_position = target_loc.position
	target_loc.unit = unit

	_grab_village(target_loc)
	_grab_castle(target_loc)

	EventBus.raise_event("place_unit", {"scenario": self, "side": get_side(unit.side_number), "unit": unit, "loc": target_loc})
	# NOTE: Currently only called in recruit and recall and add_unit


func move_unit(start_loc: Location, end_loc : Location, pop_last := false) -> Mover:
	var result = map.find_path_with_max_costs(start_loc, end_loc, start_loc.unit.moves.value)
	return _move_unit(result, start_loc, end_loc, pop_last)


func find_units(property_path: String, value) -> Array:
	if property_path == ".":
		return unit_container.get_children()

	var units := []
	var property := ""
	var node_path := ""

	var temp := property_path.split(":")

	if temp.size() == 2:
		node_path = temp[0]
		property = temp[1]
	else:
		property = temp[0]

	for unit in unit_container.get_children():
		if node_path:
			if unit.get_node(node_path).get(property) == value:
				units.append(unit)
		elif unit.get(property) == value:
				units.append(unit)
	return units


func start_combat(attacker_loc: Location, attacker_attack: Attack, defender_loc: Location, defender_attack: Attack) -> void:
	if not map.are_locations_neighbors(attacker_loc, defender_loc):
		var result := map.find_path_with_max_costs(attacker_loc, defender_loc, attacker_loc.unit.moves.value)

		if result.size() < 2:
			emit_signal("combat_finished")
			return

		var new_attacker_loc = result.path[result.path.size()-2]

		if new_attacker_loc.unit:
			Console.warn("unit at destination %s" % str(new_attacker_loc.cell))
			emit_signal("combat_finished")
			return

		var mover = move_unit(attacker_loc, defender_loc, true)

		if not mover:
			emit_signal("combat_finished")
			return

		yield(self, "unit_move_finished")
		attacker_loc = new_attacker_loc

	if not map.are_locations_neighbors(attacker_loc, defender_loc):
		emit_signal("combat_finished")
		return

	EventBus.raise_event("combat_start", {"scenario": self, \
	"attacker_side": current_side, "attacker_loc": attacker_loc, "attacker_attack": attacker_attack, \
	"defender_side": get_side(defender_loc.unit.side_number), "defender_loc": defender_loc, "defender_attack": defender_attack})

	var combat := Combat.new()
	get_tree().current_scene.add_child(combat)

	combat.connect("combat_finished", self, "_on_combat_finished")
	var attacker := CombatContext.new(attacker_loc, attacker_attack, schedule.current_time)
	var defender := CombatContext.new(defender_loc, defender_attack, schedule.current_time)
	combat.start(attacker, defender)

	attacker_loc.unit.suspend()

	yield(combat, "combat_finished")

	EventBus.raise_event("combat_finished", {"scenario": self, \
	"attacker_side": current_side, "attacker_loc": attacker_loc, "attacker_attack": attacker_attack, \
	"defender_side": get_side(defender_loc.unit.side_number), "defender_loc": defender_loc, "defender_attack": defender_attack})

	_check_victory_conditions()
	emit_signal("combat_finished")


func add_flag(_position: Vector2, color: Color) -> void:
	_position += FLAG_OFFSET
	remove_flag(_position)
	var flag : Polygon2D = load("res://source/interface/misc/Flag.tscn").instance()
	flag.color = color
	flags[_position] = flag
	flag_container.add_child(flag)
	flag.global_position = _position


func remove_flag(position: Vector2) -> void:
	if not flags.has(position):
		return

	var flag = flags[position]
	flag_container.remove_child(flag)
	flag.queue_free()


func end_turn() -> void:
	current_side.turn_end()
	current_side = get_side((current_side.number) % sides.get_child_count() + 1)

	if current_side.get_index() == 0:
		schedule.next()
		EventBus.raise_event("next_turn", {"scenario": self, "turn": turn_num})

	EventBus.raise_event("next_side", {"scenario": self, "turn": turn_num, "new_side": current_side})

	_turn_refresh_heals()
	_turn_refresh_abilities()

	current_side.turn_refresh()

	Console.write("Side %d's Turn" % current_side.number)

	if current_side.controller == Side.Controller.AI:
		get_tree().call_group("GameUI", "disable")
		var ai = AIs[current_side]
		ai.call_deferred("execute", self)
		yield(ai, "finished")
		end_turn()
		get_tree().call_group("GameUI", "enable")
		return

	get_tree().call_group("SideUI", "update_info", current_side)
	get_tree().call_group("GameCam", "set", "global_position", current_side.leaders[0].global_position)


func get_side(side_number: int):
	return sides.get_child(side_number - 1)


func get_sides() -> Array:
	return sides.get_children()


func _setup() -> void:
	map_container.name = "MapContainer"
	add_child(map_container)

	flag_container.name = "FlagContainer"
	add_child(flag_container)

	unit_container.name = "UnitContainer"
	add_child(unit_container)

	get_tree().call_group("ToDWidget", "initialize", schedule.get_times())


func _load_map() -> void:
	map = Map.instance()
	map.initialize(map_data)
	map.connect("location_hovered", self, "_on_Map_location_hovered")
	map_container.add_child(map)


func _load_sides() -> void:
	for side in get_sides():
		if (Campaign.selected_scenario.type == ScenarioData.ScenarioType.SCENARIO):
			side.set_faction(Campaign.selected_sides[side.number - 1])
		add_unit(side.number, side.leader, side.start_position.x, side.start_position.y, true)
		if (side.controller == Side.Controller.AI):
			var ai = Data.AIs[side.ai].new()
			add_child(ai)
			ai.initialize(side)
			AIs[side] = ai


	current_side = get_side(1)
	current_side.turn_refresh()

	get_tree().call_group("SideUI", "update_info", current_side)


func _move_unit(path_result: Dictionary, start_loc: Location, end_loc : Location, pop_last := false) -> Mover:
	if path_result.costs > start_loc.unit.moves.value:
		emit_signal("unit_move_finished", start_loc)
		Console.warn(start_loc.unit.name + " has not enough moves! (%d)" % path_result.costs)
		return null

	EventBus.raise_event("move_start", {"scenario": self, "side": current_side, "start_loc": start_loc, "end_loc": end_loc})

	if pop_last:
		path_result.path.pop_back()

	var loc = path_result.path[path_result.path.size()-1]

	var mover := Mover.new()

	get_tree().current_scene.add_child(mover)

	current_side.remove_castle(start_loc)

	mover.move_unit(start_loc, path_result.path)
	is_side_moving = true

	yield(mover, "unit_move_finished")

	_grab_village(loc)
	_grab_castle(loc)
	is_side_moving = false

	EventBus.raise_event("move_finished", {"scenario": self, "side": current_side, "start_loc": start_loc, "end_loc": end_loc})

	emit_signal("unit_move_finished", loc)

	return mover


func _turn_refresh_heals() -> void:
	for loc in map.locations.values():

		if loc.unit and loc.unit.team_name == current_side.team_name:

			if loc.terrain.heals and loc.unit.moves.is_full() and loc.unit.actions.is_full():
				loc.unit.heal(current_side.HEAL_ON_VILLAGE + current_side.HEAL_ON_REST, true)

			elif loc.terrain.heals:
				loc.unit.heal(current_side.HEAL_ON_VILLAGE, true)

			elif loc.unit.moves.is_full() and loc.unit.actions.is_full():
				loc.unit.heal(current_side.HEAL_ON_REST, true)


func _turn_refresh_abilities() -> void:
	for loc in map.locations.values():

		if not loc.unit or loc.unit.side_number != current_side.number:
			continue

		for ability in loc.unit.get_abilities():
			ability.execute(loc)

		for effect in loc.unit.get_effects():
			effect.execute(loc)


func _grab_village(loc: Location) -> void:
	var side : Side = get_side(loc.unit.side_number)

	if not loc.terrain.gives_income or side.has_village(loc):
		return

	if loc.side_number >= 0:
		var last_side : Side = get_side(loc.side_number)
		last_side.remove_village(loc)

	side.add_village(loc)
	loc.unit.moves.value = 0

	add_flag(loc.position, side.color)

	get_tree().call_group("SideUI", "update_info", current_side)


func _grab_castle(loc: Location) -> void:
	var side : Side = get_side(loc.unit.side_number)

	if not loc.terrain.recruit_from or side.has_castle(loc):
		return

	if loc.side_number >= 0:
		var last_side : Side = get_side(loc.side_number)
		last_side.remove_village(loc)

	side.add_castle(loc)


func _check_victory_conditions() -> void:
	for side in get_sides():
		if not side.leaders:
			victory()
			return

func victory() -> void:
	for side in get_sides():
		side.write_recall_list()

	Console.write("Side %d won!" % current_side.number)

	EventBus.raise_event("victory", {"scenario": self, "side": current_side})

	if (next_scenario):
		var next = Data.scenarios[next_scenario]
		Campaign.selected_scenario = next
		if (next.type == ScenarioData.ScenarioType.CAMPAIGN):
			Scene.change("Game")
		else:
			Scene.change("FactionSelectionMenu")
	else:
		Scene.change("TitleScreen")
		Campaign.recall_list = {}


func _on_Map_location_hovered(loc: Location) -> void:
	hovered_location = loc
	emit_signal("location_hovered", hovered_location)

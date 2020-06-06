tool
extends Node2D
class_name Scenario

signal location_hovered(loc)
signal unit_move_finished(loc)
signal combat_finished()

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


func _ready() -> void:
	if Engine.editor_hint:
		return

	_setup()
	_load_map()
	_load_sides()


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


func recruit(unit_type_id: String) -> void:
	var loc := current_side.find_recruit_location()

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
	unit.side_number = current_side.number
	unit.side_color = current_side.color
	unit.team_name = current_side.team_name
	unit.type = unit_type

	current_side.add_unit(unit)

	unit_container.add_child(unit)
	get_tree().call_group("GameUI", "add_unit_plate", unit)

	unit.apply_traits()

	place_unit(unit, loc)
	unit.suspend()

	get_tree().call_group("SideUI", "update_info", current_side)


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

	unit.apply_traits()

	get_tree().call_group("GameUI", "add_unit_plate", unit)
	place_unit(unit, map.get_location_from_cell(Vector2(x, y)))


func place_unit(unit: Unit, target_loc: Location) -> void:

	if not target_loc:
		Console.warn("invalid coordinates, cannot place unit")
		return

	unit.global_position = target_loc.position
	target_loc.unit = unit

	_grab_village(target_loc)
	_grab_castle(target_loc)


func move_unit(start_loc: Location, end_loc : Location, pop_last := false) -> Mover:
	var result = map.find_path_with_max_costs(start_loc, end_loc, start_loc.unit.moves.value)
	return _move_unit(result, start_loc, end_loc, pop_last)


func move_unit_towards(start_loc: Location, end_loc : Location, pop_last := false) -> Mover:
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

		var mover = move_unit_towards(attacker_loc, defender_loc, true)

		if not mover:
			emit_signal("combat_finished")
			return

		yield(mover, "unit_move_finished")
		attacker_loc = new_attacker_loc

	if not map.are_locations_neighbors(attacker_loc, defender_loc):
		emit_signal("combat_finished")
		return

	var combat := Combat.new()
	get_tree().current_scene.add_child(combat)

	combat.connect("combat_finished", self, "_on_combat_finished")
	var attacker := CombatContext.new(attacker_loc, attacker_attack, schedule.current_time)
	var defender := CombatContext.new(defender_loc, defender_attack, schedule.current_time)
	combat.start(attacker, defender)

	attacker_loc.unit.suspend()


func add_flag(_position: Vector2, color: Color) -> void:
	_position += FLAG_OFFSET
	remove_flag(_position)
	var flag : Polygon2D = load("res://source/interface/misc/Flag.tscn").instance()
	flag.color = color
	flags[_position] = flag
	flag_container.add_child(flag)
	flag.global_position = _position
	print("added flag")


func remove_flag(position: Vector2) -> void:
	if not flags.has(position):
		return

	var flag = flags[position]
	flag_container.remove_child(flag)
	flag.queue_free()


func end_turn() -> void:
	current_side.turn_end()
	current_side = get_side((current_side.number + 1) % sides.get_child_count())

	if current_side.get_index() == 0:
		schedule.next()

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


func get_side(index: int):
	return sides.get_child(index)


func get_sides() -> Array:
	return sides.get_children()


func _setup() -> void:
	map_container.name = "MapContainer"
	add_child(map_container)

	flag_container.name = "FlagContainer"
	add_child(flag_container)

	unit_container.name = "UnitContainer"
	add_child(unit_container)


func _load_map() -> void:
	map = Map.instance()
	map.initialize(map_data)
	map.connect("location_hovered", self, "_on_Map_location_hovered")
	map_container.add_child(map)


func _load_sides() -> void:
	for side in get_sides():
		add_unit(side.number, side.leader, side.start_position.x, side.start_position.y, true)
		var ai = Data.AIs[side.ai].new()
		add_child(ai)
		ai.initialize(side)
		AIs[side] = ai


	current_side = get_side(0)
	current_side.turn_refresh()

	get_tree().call_group("SideUI", "update_info", current_side)


func _move_unit(path_result: Dictionary, start_loc: Location, end_loc : Location, pop_last := false) -> Mover:
	if path_result.costs > start_loc.unit.moves.value:
		emit_signal("unit_move_finished", start_loc)
		Console.warn(start_loc.unit.name + " has not enough moves! (%d)" % path_result.costs)
		return null

	if pop_last:
		path_result.path.pop_back()

	var mover := Mover.new()
	mover.connect("unit_move_finished", self, "_on_Mover_unit_move_finished")
	get_tree().current_scene.add_child(mover)

	current_side.remove_castle(start_loc)

	mover.move_unit(start_loc, path_result.path)
	is_side_moving = true
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
		last_side.remove_town(loc)

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
		last_side.remove_town(loc)

	side.add_castle(loc)


func _check_victory_conditions() -> void:
	var victory := true

	for side in get_sides():
		if not side == current_side:
			if side.leaders:
				victory = false

	if victory:
		Console.write("Side %d won!" % current_side.number)
		get_tree().reload_current_scene()


func _on_combat_finished() -> void:
	_check_victory_conditions()
	emit_signal("combat_finished")


func _on_Map_location_hovered(loc: Location) -> void:
	hovered_location = loc
	emit_signal("location_hovered", hovered_location)


func _on_Mover_unit_move_finished(loc: Location) -> void:
	_grab_village(loc)
	_grab_castle(loc)
	is_side_moving = false
	emit_signal("unit_move_finished", loc)

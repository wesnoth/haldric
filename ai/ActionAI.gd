extends	AI
class_name ActionAI

signal attacks_finished()
signal scouting_finished()
signal recruit_finished()

"""
Action based AI

Step 1: Analyze the Battlefield
Step 2: Attack / Retreat
atep 3: Position Heals
Step 4: Reinforce
Step 5: Scout
Step 6: Recruit
"""

class EntrySorter:

	static func sort_distance_ascending(a, b):

		if a.distance < b.distance:
			return true

		return false


var castles := []
var villages := []
var units := []

var free_villages := []

var my_units := []
var my_leaders := []
var my_villages := []

var allies := []
var ally_villages := []

var enemies := []
var enemy_leaders := []
var enemy_villages := []


func _initialize(side: Side) -> void:
	_reset()


func _reset() -> void:
	castles = []
	villages = []
	units = []

	free_villages = []

	my_units = []
	my_leaders = []
	my_villages = []

	allies = []
	ally_villages = []

	enemies = []
	enemy_leaders = []
	enemy_villages = []


func _execute(scenario: Scenario) -> void:
	_reset()
	_analyze(scenario)
	call_deferred("_execute_attacks", scenario)

	yield(self, "attacks_finished")

	_reset()
	_analyze(scenario)
	call_deferred("_execute_scouting", scenario)

	yield(self, "scouting_finished")

	_reset()
	_analyze(scenario)
	call_deferred("_execute_recruit", scenario)

	yield(self, "recruit_finished")

	Console.write("AI executed")
	emit_signal("finished")


func _execute_attacks(scenario: Scenario) -> void:
	randomize()

	Console.write("Execute Attacks")

	for entry in my_units:
		var loc : Location = entry.loc
		var distance : int = entry.distance

		if loc.unit.is_leader:
			continue

		if loc.unit.actions.is_empty():
			continue

		if not loc.unit.type.usage in [UnitType.Usage.FIGHTER, UnitType.Usage.ARCHER, UnitType.Usage.MIXED_FIGHTER, UnitType.Usage.HEALER]:
			continue

		var reachable_enemies := _get_reachable_enemies(scenario.map.find_reachable_cells(loc, loc.unit).keys())

		var target := {}

		if reachable_enemies:
			target = _get_best_attack_target(loc.unit, reachable_enemies)
			scenario.call_deferred("start_combat", loc, loc.unit.get_attacks()[0], target.loc, target.loc.unit.get_attacks()[0])
			yield(scenario, "combat_finished")

		else:
			target = _get_best_attack_target(loc.unit, enemies)
			scenario.call_deferred("move_unit", loc, target.loc)
			yield(scenario, "unit_move_finished")

	emit_signal("attacks_finished")


func _execute_scouting(scenario: Scenario) -> void:

	for entry in my_units:
		var loc : Location = entry.loc
		var distance : int = entry.distance

		if loc.unit.is_leader:
			continue

		if loc.unit.actions.is_empty():
			continue

		if not loc.unit.type.usage in [UnitType.Usage.SCOUT]:
			continue

		var target_villages = free_villages + enemy_villages

		print(free_villages)
		print(enemy_villages)
		print(target_villages)

		if target_villages:
			var target : Dictionary = target_villages[randi() % target_villages.size()]
			scenario.move_unit(loc, target.loc)
			yield(scenario, "unit_move_finished")

	emit_signal("scouting_finished")


func _execute_recruit(scenario: Scenario) -> void:
	Console.write("Execute Recruits")

	while scenario.current_side.can_recruit():

		var list = scenario.current_side.recruit
		var recruit_id = list[randi() % list.size()]

		var unit_type = Data.units[recruit_id].instance()

		if unit_type.cost > scenario.current_side.gold:
			break

		scenario.recruit(recruit_id)

		yield(get_tree().create_timer(0.1), "timeout")


	emit_signal("recruit_finished")


func _get_reachable_enemies(reachable_cells: Array) -> Array:
	var reachable_enemies := []

	for entry in enemies:
		var loc : Location = entry.loc

		if reachable_cells.has(loc.cell):
			reachable_enemies.append(entry)

	return reachable_enemies


func _get_best_attack_target(attacker: Unit, targets: Array) -> Dictionary:
	return targets[randi() % targets.size()]


func _sort_distance_ascending(array: Array, loc: Location) -> void:
	array.sort_custom(EntrySorter, "sort_distance_ascending")
	pass


func _analyze(scenario: Scenario) -> void:
	Console.write("Analyzing Battlefield")

	for cell in scenario.map.locations:
		var loc : Location = scenario.map.locations[cell]
		_analyze_location_castles(scenario, loc)
		_analyze_location_villages(scenario, loc)
		_analyze_location_units(scenario, loc)


func _analyze_location_castles(scenario: Scenario, loc: Location) -> void:
	if loc.castle:
		_add_location_entry(castles, loc)


func _analyze_location_villages(scenario: Scenario, loc: Location) -> void:

	if loc.terrain.gives_income:
		_add_location_entry(villages, loc)

		if loc.side_number == -1:
			_add_location_entry(free_villages, loc)

		elif loc.side_number == scenario.current_side.number:
			_add_location_entry(my_villages, loc)

		elif loc.team_name == scenario.current_side.team_name:
			_add_location_entry(ally_villages, loc)

		else:
			_add_location_entry(enemy_villages, loc)


func _analyze_location_units(scenario: Scenario, loc: Location) -> void:
	if loc.unit:
		_add_location_entry(units, loc)

		if loc.unit.team_name != scenario.current_side.team_name:
			_add_location_entry(enemies, loc)

			if loc.unit.is_leader:
				_add_location_entry(enemy_leaders, loc)

		elif loc.unit.side_number == scenario.current_side.number:
			_add_location_entry(my_units, loc)

			if loc.unit.is_leader:
				_add_location_entry(my_leaders, loc)

		else:
			_add_location_entry(allies, loc)


func _add_location_entry(array: Array, loc: Location) -> void:
	var entry = {
		"loc": loc,
		"distance": 0
	}

	array.append(entry)

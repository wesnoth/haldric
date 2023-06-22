extends AI

enum State { NONE, RECRUIT, CAPTURE_VILLAGES, ATTACK, RETREAT }
enum UnitState { NONE, HEAL, SCOUT, ATTACK, STANDBY }

var state : int = State.RECRUIT
var unitstates := {}

"""
AI:

	SWITCH UNIT_STATE:
		*:
			IF HP < 1/3:
				DO HEAL
			IF AI_STATE = RETREAT:
				DO RETREAT

		HEAL:
			IF HP < 1/3:
				IF NOT ON VILLAGE:
					MOVE TOWARDS NEAREST VILLAGE
					NEXT HEAL
				ELSE:
					DO NOTHING
					NEXT HEAL
			IF HP > 2/3:
				DO ATTACK

		ATTACK:
			GO TOWARDS NEAREST ENEMY UNIT
			ATTACK
			NEXT ATTACK

		STANDBY:
			IF AI_STATE = ATTACK
				DO ATTACK
			IF AI_STATE = CAPTURE_VILLAGES:
				MOVE TOWARDS NEAREST UNOCCUPIED VILLAGE
				NEXT STANDBY
			IF AI_STATE = RECRUIT AND LEADER:
				IF HAS_GOLD:
					RECRUIT
				ELSE:
					AI_STATE = CAPTURE_VILLAGES
			IF AI_STATE = RETREAT:
				DO RETREAT

		SCOUT:
			MOVE TOWARDS NEAREST UNOCCUPIED VILLAGE
			NEXT SCOUT

		RETREAT:
			MOVE TOWARD LEADER
			IF LEADER:
				MOVE TOWARD KEEP
			NEXT RETREAT

"""


func _initialize(side: Side) -> void:
	state = State.RECRUIT

	for unit in side.units:
		_add_unit(unit)

	side.connect("unit_added", self, "_add_unit")
	side.connect("unit_removed", self, "_remove_unit")


func _execute(scenario: Scenario) -> void:
	Console.write("Executing AI")

	for unit in unitstates.keys():
		var ustate = self.unitstates[unit]
		match ustate:
			_:
				if do_all(scenario, state, unit):
					continue
			UnitState.HEAL:
				if do_heal(scenario, state, unit):
					continue
			UnitState.ATTACK:
				if do_attack(scenario, state, unit):
					continue
			UnitState.STANDBY:
				if do_standby(scenario, state, unit):
					continue
			UnitState.SCOUT:
				if do_scout(scenario, state, unit):
					continue

			UnitState.NONE:
				pass

	Console.write("Finished Executing AI")
	emit_signal("finished")


func do_all(scenario: Scenario, unit_state: int, unit: Unit) -> bool:
	"""
	*:
		IF HP < 1/3:
			DO HEAL
		IF AI_STATE = RETREAT:
			DO RETREAT
		ALSO RECRUIT IF LEADER
	"""
	if not unit.health.has_third():
		do_heal(scenario, unit_state, unit)
	if state == State.RETREAT:
		do_standby(scenario, unit_state, unit)
	if state == State.RECRUIT and unit in scenario.current_side.leaders:
		scenario.recruit(scenario.current_side.recruit[0])
		return false

	return true


func do_heal(scenario: Scenario, unit_state: int, unit: Unit) -> void:
	"""
	HEAL:
		IF HP < 1/3:
			IF NOT ON VILLAGE:
				MOVE TOWARDS NEAREST VILLAGE
				NEXT HEAL
			ELSE:
				DO NOTHING
				NEXT HEAL
		IF HP > 2/3:
			DO ATTACK
	"""
	if not unit.health.has_third():
		var loc = scenario.map.get_location_from_world(unit.position)
		var hloc = _get_nearest_healing(loc)
		if hloc:
			scenario.move_unit(loc, hloc[0], hloc[1])
			yield(scenario, "unit_move_finished")
	else:
		do_attack(scenario, unit_state, unit)


func do_scout(scenario: Scenario, unit_state: int, unit: Unit) -> void:
	"""
	SCOUT:
		MOVE TOWARDS NEAREST UNOCCUPIED VILLAGE
		NEXT SCOUT
	"""
	var loc = scenario.map.get_location_from_world(unit.position)
	if loc.terrain.heals:
		self.state = UnitState.STANDBY
	else:
		var hloc = _get_nearest_village(loc)
		if hloc:
			scenario.move_unit(loc, hloc)
			yield(scenario, "unit_move_finished")


func do_attack(scenario: Scenario, unit_state: int, unit: Unit) -> void:
	"""
	ATTACK:
		GO TOWARDS NEAREST ENEMY UNIT
		ATTACK
		NEXT ATTACK
	"""
	var loc = scenario.map.get_location_from_world(unit.position)
	var hloc = _get_nearest_enemy(loc)
	if hloc:
		print(loc.unit, hloc.unit)
		scenario.start_combat(loc, loc.unit.type.attacks.get_children()[0], hloc, hloc.unit.type.attacks.get_children()[0])
		yield(scenario, "combat_finished")


func do_standby(scenario: Scenario, unit_state: int, unit: Unit) -> void:
	"""
	STANDBY:
		IF AI_STATE = ATTACK
			DO ATTACK
		IF AI_STATE = CAPTURE_VILLAGES:
			MOVE TOWARDS NEAREST UNOCCUPIED VILLAGE
			NEXT STANDBY
		IF AI_STATE = RETREAT:
			DO RETREAT
	"""
	if state == State.ATTACK or state == State.RECRUIT:
		do_attack(scenario, unit_state, unit)
	if state == State.CAPTURE_VILLAGES:
		do_scout(scenario, unit_state, unit)
	if state == State.RETREAT:
		do_retreat(scenario, unit_state, unit)


func do_retreat(scenario: Scenario, unit_state: int, unit: Unit) -> void:
	var loc = scenario.map.get_location_from_world(unit.position)
	var hloc = scenario.current_side.leaders[0]
	scenario.move_unit(loc, hloc)
	yield(scenario, "unit_move_finished")


func _get_nearest_healing(loc: Location) -> Array:
	var visited := [loc]
	var queue := [loc]

	while len(queue) > 0:

		var q_loc : Location = queue.pop_front()

		for n_loc in q_loc.get_neighbors():

			if n_loc in visited:
				continue

			visited.append(n_loc)
			queue.append(n_loc)

			if (n_loc.terrain.heals and not n_loc.unit) or \
			(n_loc.unit.type.usage == UnitType.Usage.HEALER and n_loc.unit.side_number != loc.unit.side_number):
				return [n_loc, n_loc.unit != null]

	return []


func _get_nearest_village(loc: Location) -> Location:
	var visited := [loc]
	var queue := [loc]

	while len(queue) > 0:

		var q_loc : Location = queue.pop_front()

		for n_loc in q_loc.get_neighbors():

			if n_loc in visited:
				continue

			visited.append(n_loc)
			queue.append(n_loc)

			if n_loc.terrain.heals and not n_loc.unit:
				return n_loc

	return null


func _get_nearest_enemy(loc: Location) -> Location:
	var visited := [loc]
	var queue := [loc]

	while len(queue) > 0:
		var q_loc : Location = queue.pop_front()

		for n_loc in q_loc.get_neighbors():

			if n_loc in visited:
				continue

			visited.append(n_loc)
			queue.append(n_loc)

			if n_loc.unit and n_loc.unit.side_number != loc.unit.side_number:
				return n_loc

	return null


func _add_unit(unit: Unit) -> void:
	unitstates[unit] = UnitState.STANDBY


func _remove_unit(unit: Unit) -> void:
	unitstates.erase(unit)

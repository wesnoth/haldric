extends Node
class_name AI

signal finished()

enum State {NONE, RECRUIT, CAPTURE_VILLAGES, ATTACK, RETREAT}
enum UnitState {NONE, HEAL, SCOUT, ATTACK, STANDBY}

var side;
var state = State.RECRUIT;
var unitstates = {};
var scenario = null;

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

func _init(side):
	self.side = side
	self.state = State.RECRUIT

	for unit in side.units:
		_add_unit(unit)

	side.connect("side_add_unit", self, "_add_unit")
	side.connect("side_remove_unit", self, "_remove_unit")

func execute(scenario) -> void:
	Console.write("Executing AI")

	self.scenario = scenario

	for unit in unitstates.keys():
		var ustate = self.unitstates[unit]
		match ustate:
			_:
				if do_all(state, unit):
					continue
			UnitState.HEAL:
				if do_heal(state, unit):
					continue
			UnitState.ATTACK:
				if do_attack(state, unit):
					continue
			UnitState.STANDBY:
				if do_standby(state, unit):
					continue
			UnitState.SCOUT:
				if do_scout(state, unit):
					continue

			UnitState.NONE:
				pass

	Console.write("Finished Executing AI")
	emit_signal("finished")

func do_all(unit_state, unit):
	"""
	*:
		IF HP < 1/3:
			DO HEAL
		IF AI_STATE = RETREAT:
			DO RETREAT
		ALSO RECRUIT IF LEADER
	"""
	if not unit.health.has_third():
		do_heal(unit_state, unit)
	if state == State.RETREAT:
		do_standby(unit_state, unit)
	if state == State.RECRUIT and unit in side.leaders:
		scenario.recruit(side.recruit[0])

	return true


func do_heal(unit_state, unit):
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
		var loc = self.scenario.map.get_location_from_world(unit.position)
		var hloc = _get_nearest_healing(loc)
		if hloc:
			scenario.move_unit(loc, hloc[0], hloc[1])
	else:
		do_attack(unit_state, unit)

func do_scout(unit_state, unit):
	"""
	SCOUT:
		MOVE TOWARDS NEAREST UNOCCUPIED VILLAGE
		NEXT SCOUT
	"""
	var loc = self.scenario.map.get_location_from_world(unit.position)
	if loc.heals:
		self.state = UnitState.STANDBY
	else:
		var hloc = _get_nearest_village(loc)
		if hloc:
			scenario.move_unit(loc, hloc)

func do_attack(unit_state, unit):
	"""
	ATTACK:
		GO TOWARDS NEAREST ENEMY UNIT
		ATTACK
		NEXT ATTACK
	"""
	var loc = self.scenario.map.get_location_from_world(unit.position)
	var hloc = _get_nearest_enemy(loc)
	if hloc:
		scenario.start_combat(loc, loc.unit.type.attacks.get_children()[0], hloc, hloc.unit.type.attacks.get_children()[0])

func do_standby(unit_state, unit):
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
		do_attack(unit_state, unit)
	if state == State.CAPTURE_VILLAGES:
		do_scout(unit_state, unit)
	if state == State.RETREAT:
		do_retreat(unit_state, unit)

func do_retreat(unit_state, unit):
	var loc = self.scenario.map.get_location_from_world(unit.position)
	var hloc = side.leaders[0]
	scenario.move_unit(loc, hloc)

func _get_nearest_healing(loc: Location):
	var visited := [loc]
	var queue := [loc]

	while len(queue) > 0:
		
		var q_loc : Location = queue.pop_front()

		for n_loc in q_loc.get_neighbors():

			if n_loc in visited:
				continue

			visited.append(n_loc)
			queue.append(n_loc)

			if (n_loc.heals and not n_loc.unit) or \
			(n_loc.unit.type.usage == UnitType.Usage.HEALER and n_loc.unit.side_number != loc.unit.side_number):
				return [n_loc, n_loc.unit != null]

	return null

func _get_nearest_village(loc: Location):
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

func _get_nearest_enemy(loc: Location):
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

func _add_unit(unit):
	unitstates[unit] = UnitState.STANDBY

func _remove_unit(unit):
	unitstates.erase(unit)

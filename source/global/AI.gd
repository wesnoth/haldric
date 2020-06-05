extends Node
class_name AI

signal finished()

enum State {NONE, RECRUIT, CAPTURE_VILLAGES, ATTACK, RETREAT}
enum UnitState {NONE, HEAL, SCOUT, ATTACK, STANDBY}

var side;
var state = State.NONE;
var unitstates = {};
var units = {};

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
	
	side.connect("side_add_unit", self, "_add_unit")
	side.connect("side_remove_unit", self, "_remove_unit")

func execute(scenario) -> void:
	Console.write("Executing AI")
	
	for unitname in unitstates.keys:
		var state = self.unitstates[unitname]
		var unit = self.units[unitname]
		match state:
			_:
				if do_all(unitname, state, unit):
					continue
			UnitState.HEAL:
				if do_heal(unitname, state, unit):
					continue
			UnitState.ATTACK:
				if do_attack(unitname, state, unit):
					continue
			UnitState.STANDBY:
				if do_standby(unitname, state, unit):
					continue
			UnitState.SCOUT:
				if do_scout(unitname, state, unit):
					continue
			
			UnitState.NONE:
				pass
	
	Console.write("Finished Executing AI")
	emit_signal("finished")

func do_all(unitname, unit_state, unit):
	"""
	*:
	IF HP < 1/3:
		DO HEAL
	IF AI_STATE = RETREAT:
		DO RETREAT
	"""
	if not unit.health.has_third():
		do_heal(unitname, unit_state, unit)
	if state == State.RETREAT:
		do_standby(unitname, unit_state, unit)
	

func do_heal(unitname, unit_state, unit):
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
		pass # move towards village
	else:
		do_attack(unitname, unit_state, unit)

func do_scout(unitname, unit_state, unit):
	pass

func do_attack(unitname, unit_state, unit):
	pass

func do_standby(unitname, unit_state, unit):
	pass

func _get_nearest_healing(loc: Location):
	var visited := [loc]

	while true:
		var q_loc : Location = visited.pop_front()

		for n_loc in q_loc.get_neighbors():

			if n_loc in visited:
				continue

			visited.append(n_loc)

			if n_loc.heals or n_loc.unit.type.usage == UnitType.Usage.HEALER:
				return [n_loc, n_loc.unit.type.usage == UnitType.Usage.HEALER]

	return null

func _add_unit(unit):
	unitstates[unit.name] = UnitState.STANDBY
	units[unit.name] = unit

func _remove_unit(unit):
	unitstates.erase(unit.name)
	units.erase(unit.name)

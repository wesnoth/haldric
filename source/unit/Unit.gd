extends Node2D
class_name Unit

var thread = Thread.new()

signal experienced(unit)

signal moved(unit, location)
signal move_finished(unit, location, halt)
signal state_changed(new_state)

var side : Side = null

var health_current := 0
var moves_current := 0
var experience_current := 0 setget _set_experience_current

var location: Location = null

var path := []
var reachable := {}
var viewable := []

var type : UnitType = null

var current_state : State = null

onready var states := {
	idle = $States/Idle,
	move = $States/Move,
	attack = $States/Attack,
}

onready var tween := $Tween as Tween
onready var state_label := $StateLabel as Label

onready var life_bar := $LifeBar as Control

func _unhandled_input(event: InputEvent) -> void:
	current_state.input(self, event)

func _process(delta: float) -> void:
	current_state.update(self, delta)
	life_bar.update_unit(self)

func _ready() -> void:
	add_child(type)
	change_state("idle")
	reset()

func advance(unit_type: UnitType) -> void:
	remove_child(type)
	type = unit_type
	add_child(type)
	reset()

func reset() -> void:
	health_current = type.health
	moves_current = type.moves
	experience_current = 0

func change_state(new_state):
	if current_state:
		current_state._exit(self)
	current_state = states[new_state]
	state_label.text = current_state.name
	current_state._enter(self)
	emit_signal("state_changed", current_state.name)

func place_at(loc: Location) -> void:
	if location:
		location.unit = null

	location = loc
	position = location.position
	location.unit = self
	set_reachable() # TODO: do we want this?

func path_cost(unit_path : Array) -> int:
	var cost = 0
	for loc in unit_path:
		if loc.unit:
			if not loc.unit.side.number == side.number:
				break #going to assume this is the end and nothing else needs to be added to cost
		cost += get_movement_cost(loc)
	return cost

func move_to(new_path: Array) -> void:
	path = new_path
	change_state("move")

func receive_attack(attack: Attack) -> void:
	health_current -= attack.damage
	print("{name} received {dmg} damage".format({'name':type.id,'dmg':attack.damage}))

func found_matching_attack(target: Unit, attack: Attack) -> Attack:
	for ennemy_attack in target.type.get_attacks():
		if(ennemy_attack.reach == attack.reach):
			return ennemy_attack

	#return an empty attack if no matching attack is found
	var empty_attack = Attack.new()
	return empty_attack

func execute_attack(target: Unit, attack: Attack) -> void:
	var attacker_attack = attack
	var defender_attack = found_matching_attack(target, attack)

	var attacker_strikes = attacker_attack.strikes
	var defender_strikes = defender_attack.strikes
	while attacker_strikes > 0 or defender_strikes > 0:
		if attacker_strikes > 0:
			target.receive_attack(attacker_attack)
			attacker_strikes -= 1
		if defender_strikes > 0:
			self.receive_attack(defender_attack)
			defender_strikes -= 1

func get_movement_cost(loc: Location) -> int:
	var cost = type.movement.get(loc.terrain.type[0])
	if loc.terrain.type.size() > 1:
		var cost_overlay = type.movement.get(loc.terrain.type[1])
		cost = max(cost_overlay, cost)
	return cost

func get_defense() -> int:
	var defense = type.defense.get(location.terrain.type[0])
	if location.terrain.type.size() > 1:
		var defense_overlay = type.defense.get(location.terrain.type[1])
		defense = max(defense_overlay, defense)
	return defense

func get_time_percentage() -> int:
	return location.terrain.time.get_percentage(type.alignment)

func set_reachable(viewable: bool = true) -> void:
	if viewable:
		update_viewable()

	thread.start(location.map, "threadable_find_all_reachable_cells", [self])
	reachable = thread.wait_to_finish()
	#reachable = location.map.threadable_find_all_reachable_cells([self]) #Debug

func update_viewable() -> bool:
	if side.fog:
		var new_unit_found = false
		if viewable.empty():
			thread.start(location.map, "threadable_find_all_reachable_cells", [self,true,true])
			var temp = thread.wait_to_finish()
			if temp:
				viewable = temp.keys()
				for loc in viewable:
					side.viewable[loc] = 1
					if loc.unit:
						if not loc.unit.side == side:
							new_unit_found = true
							side.viewable_units[loc.unit] = 1
		else:
			return location.map.extend_viewable(self) #do not thread, causes a lot of issues when threaded for some reason
		return new_unit_found
	return false

func _set_experience_current(value: int) -> void:
	experience_current = value
	if experience_current >= type.experience:
		if type.advances_to:
			emit_signal("experienced", self)
		else:
			_amla()

func _amla() -> void:
	type.health += 3
	type.experience *= 1.2
	reset()

func refresh_unit() -> void:
	"""
	Refreshes unit state at turn start
	* Resets unit movement
	* Heals unit as per leftover movement
	* Does damage if poisoned 
	* etc
	"""
	if health_current < type.health:
		var heal = 0
		if moves_current == type.moves:
			heal += side.HEAL_ON_REST # If the unit did not move last turn, it recovers 2 HP
		if location in side.villages:
			heal += side.HEAL_ON_VILLAGE # If the unit is in a village, it recovers 8 HP 
		if heal + health_current > type.health:
			heal = type.health - health_current
		health_current += heal
		print("{name} healed {heal} HP for resting".format({'name':type.id, 'heal':heal}))
	moves_current = type.moves # If the unit moved last turn, it recovers to its max move
	viewable.clear()
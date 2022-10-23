class_name CombatContext



var _time : CustomTime = null
var _attack = null # : Attack

var location = null # : Location
var unit = null # : Unit
var terrain : Terrain = null

var alias := ""
var damage := 0
var strikes := 0
var accuracy := 0

var damage_type := ""
var category := ""


func _init(_location, attack, time: CustomTime) -> void:
	location = _location
	_attack = attack
	_time = time

	terrain = location.terrain
	unit = location.unit

	reset()


func fire(target) -> void:
	if not _attack:
		return

	_attack.fire(location, target)


func apply_specials(_self: CombatContext, opponent: CombatContext, offender: CombatContext, defender: CombatContext) -> void:
	if not _attack:
		return

	_attack.execute_specials(_self, opponent, offender, defender)


func reset() -> void:
	if not _attack:
		return

	alias = _attack.alias
	damage = _attack.damage * _time.get_modifier(location.unit.type.alignment)
	strikes = _attack.strikes
	accuracy = _attack.accuracy

	damage_type = _attack.damage_type
	category = _attack.category


func find_counter_attack(attack): # -> Attack
	return unit.get_counter_attack(attack)


func get_accuracy_modifier() -> float:
	return (float(accuracy) / 100)


func get_defense_modifier() -> float:
	return float(unit.get_defense(terrain.type)) / 100


func get_specials() -> Array:
	if _attack:
		return _attack.specials
	return []


func has_attack() -> bool:
	return _attack != null


func to_string() -> String:
	if _attack:
		return "Damage: %d (%d), Strikes: %d, Accuracy: %d, ToD: %f" % [damage, _attack.damage, strikes, accuracy, _time.get_modifier(location.unit.type.alignment)]
	return "Damage: %d, Strikes: %d, Accuracy: %d, ToD: %f" % [damage, strikes, accuracy, _time.get_modifier(location.unit.type.alignment)]

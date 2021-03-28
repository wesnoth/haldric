extends Command
class_name CombatUnitCommand

var _attacker_loc: Location = null
var _defender_loc: Location = null
var _attacker_attack: Attack = null
var _defender_attack: Attack = null
var _current_time: Time = null


func _init(current_time: Time, attacker_loc: Location, attacker_attack: Attack, defender_loc: Location, defender_attack: Attack) -> void:
	_current_time = current_time
	_attacker_loc = attacker_loc
	_defender_loc = defender_loc
	_attacker_attack = attacker_attack
	_defender_attack = defender_attack


func _execute() -> void:
	_attacker_loc.unit.suspend()

	var combat := Combat.new()
	Global.get_tree().current_scene.add_child(combat)
	combat.connect("finished", self, "_on_combat_finished")

	combat.connect("attacker_hit", self, "_on_combat_event", ["attacker_hit"])
	combat.connect("attacker_missed", self, "_on_combat_event", ["attacker_missed"])
	combat.connect("defender_hit", self, "_on_combat_event", ["defender_hit"])
	combat.connect("defender_missed", self, "_on_combat_event", ["defender_missed"])

	var attacker := CombatContext.new(_attacker_loc, _attacker_attack, _current_time)
	var defender := CombatContext.new(_defender_loc, _defender_attack, _current_time)
	
	trigger_event("attack", [attacker, defender])

	combat.start(attacker, defender)


func _on_combat_event(attacker: CombatContext, defender: CombatContext, event: String):
	trigger_event(event, [attacker, defender])


func _on_combat_finished() -> void:
	print("attacked from ", _attacker_loc.cell, " to ", _defender_loc.cell)
	trigger_event("combat_finished")
	_finished()

extends Node
class_name Combat

signal combat_finished()

export var min_death_xp := 4
export var death_xp := 8

export var combat_speed := 0.3

onready var tween := Tween.new()


func _ready() -> void:
	tween.name = "Tween"
	add_child(tween)


func start(attacker: CombatContext, defender: CombatContext) -> void:
	randomize()

	var opponent := {}

	opponent[attacker] = defender
	opponent[defender] = attacker

	var queue := _make_attack_queue(attacker, defender)

	while queue:
		var current = queue.pop_front()
		var other = opponent[current]
		var origin = current.unit.global_position

		if current.category == "melee":
			_tween_attack(current.unit, other.unit)
			yield(tween, "tween_completed")

			_strike(current, other, attacker, defender)

			_tween_retreat(current.unit, origin)
			yield(tween, "tween_completed")

		else:
			current.fire(other.location)

			yield(get_tree().create_timer(combat_speed), "timeout")

			_strike(current, other, attacker, defender)

			yield(get_tree().create_timer(combat_speed), "timeout")

		if other.unit.is_dead():
			current.unit.grant_experience(max(min_death_xp, death_xp * other.unit.type.level))
			other.unit.kill()
			emit_signal("combat_finished")
			queue_free()
			return

	var defender_level = defender.unit.type.level
	var attacker_level = attacker.unit.type.level

	attacker.unit.grant_experience(defender_level)
	defender.unit.grant_experience(attacker_level)

	emit_signal("combat_finished")
	queue_free()


func _strike(current: CombatContext, other: CombatContext, attacker: CombatContext, defender: CombatContext) -> void:

	var accuracy = 1.0 - other.get_defense_modifier()

	if current.has_attack():
		current.apply_specials(current, other, attacker, defender)
		accuracy = max(accuracy, current.get_accuracy_modifier())

	print(current.to_string())

	if randf() < accuracy:
		other.unit.hurt(current.damage, current.damage_type)
	else:
		get_tree().call_group("GameUI", "spawn_popup_label", other.unit.global_position + Vector2(0, -48), "Miss!", 16, Color.gray, 100, 0.2)

	current.reset()


func _tween_attack(attacker: Unit, defender: Unit) -> void:
	var target_position = (attacker.global_position + defender.global_position) * 0.5
	tween.interpolate_property(attacker.type.sprite, "global_position", attacker.type.global_position, target_position, combat_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _tween_retreat(unit: Unit, origin: Vector2) -> void:
	tween.interpolate_property(unit.type.sprite, "global_position", unit.type.sprite.global_position, unit.global_position, combat_speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _make_attack_queue(attacker: CombatContext, defender: CombatContext) -> Array:
	var queue = []

	for i in max(attacker.strikes, defender.strikes):
		if attacker.strikes > i:
			queue.append(attacker)
		if defender.strikes > i:
			queue.append(defender)

	return queue

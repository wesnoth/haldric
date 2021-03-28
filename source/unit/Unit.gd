extends Node2D
class_name Unit

enum UpkeepType { FREE, LOYAL, FULL }

const REFRESH_HEAL_MAXIMUM = 10

signal advanced(unit)
signal died(unit)
signal turn_end()

var alias = ""

var side_number := 0
var side_color := Color.pink
var team_name := ""

var actions := Attribute.new()
var health := Attribute.new()
var moves := Attribute.new()
var experience := Attribute.new()

var type : UnitType = null
var race : Race = null

var upkeep : int = UpkeepType.FULL

var attacks := []

var heal_on_refresh := 0

var can_attack := true
var is_leader := false setget _set_is_leader

var brightness = 1.0 setget _set_brightness

export var mat: Material = null

onready var tween := $Tween as Tween
onready var ui_hook := $UIHook as RemoteTransform2D

onready var traits := Node.new()
onready var effects := Node.new()

static func instance() -> Unit:
	return load("res://source/unit/Unit.tscn").instance() as Unit


func _ready() -> void:
	traits.name = "Traits"
	add_child(traits)
	effects.name = "Effects"
	add_child(effects)
	set_type(type, false)


func advance(advancement: Advancement, silent := false) -> void:
	if silent:
		advancement.execute(self)
		return

	_tween_advancement_in()
	yield(tween, "tween_all_completed")

	advancement.execute(self)
	restore()

	_tween_advancement_out()
	yield(tween, "tween_all_completed")

	emit_signal("advanced", self)


func hurt(attack_damage: int, damage_type := "") -> void:
	var damage = calculate_damage(attack_damage, damage_type)

	health.value -= damage

	get_tree().call_group("GameUI", "spawn_popup_label", global_position + Vector2(0, -48), str(damage), 24, Color.red)

	_tween_hurt()

	var resistance := get_resistance(damage_type)

	print("%d Damage dealt to %s (D: %d, R: %d)" % [damage, name, attack_damage, resistance])


func heal(amount: int, on_refresh := false) -> void:
	amount = min(amount, health.get_difference())

	if not amount:
		return

	if on_refresh:
		heal_on_refresh = min(REFRESH_HEAL_MAXIMUM, heal_on_refresh + amount)
		return

	health.value += amount

	get_tree().call_group("GameUI", "spawn_popup_label", global_position + Vector2(0, -48), str(amount), 24, Color.green)

	_tween_heal()


func kill() -> void:
	emit_signal("died", self)
	queue_free()


func suspend() -> void:
	moves.empty()
	actions.empty()


func refresh() -> void:

	for skill in get_skills():
		skill.tick()

	for trait in traits.get_children():
		trait.execute_refresh(self)

	if heal_on_refresh:
		heal(heal_on_refresh)
		heal_on_refresh = 0


func grant_experience(amount: int) -> void:
	experience.value += amount

	if not experience.is_full():
		return

	var advancements = get_advancements()

	if advancements.size() > 1:
		get_tree().call_group("GameUI", "show_advancement_dialogue", self)

	elif advancements.size() == 1:
		var advancement : Advancement = advancements[0]
		if advancement.force_display:
			get_tree().call_group("GameUI", "show_advancement_dialogue", self)
		else:
			advance(advancement)
	else:
		advance(Data.DefaultAmla)


func turn_end() -> void:
	emit_signal("turn_end")

	actions.fill()
	moves.fill()


func reset() -> void:
	actions.maximum = 1
	health.maximum = type.health
	moves.maximum = type.moves
	experience.maximum = type.experience


func restore() -> void:
	actions.fill()
	health.fill()
	moves.fill()
	experience.empty()


func new_traits() -> void:
	for child in traits.get_children():
		traits.remove_child(child)
		child.queue_free()
	reset()
	var rand_traits = race.get_random_traits()

	for trait in rand_traits:
		if traits.get_child_count() == race.trait_count:
			break
		traits.add_child(trait.instance())


func apply_traits() -> void:
	for trait in traits.get_children():
		trait.execute(self)


func select() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(self, "brightness", 1.0, 2.2, 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
	__ = tween.interpolate_property(self, "brightness", 2.0, 1.3, 0.1, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.15)
	__ = tween.start()


func deselect() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(self, "brightness", 2.0, 1.0, 0.05, Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = tween.start()


func get_upkeep() -> int:

	if upkeep in [ UpkeepType.FREE, UpkeepType.LOYAL]:
		return 0

	return type.level


func get_attacks() -> Array:
	return type.attacks.get_children()


func get_skills() -> Array:
	return type.skills.get_children()


func get_abilities() -> Array:
	return type.abilities.get_children()


func get_advancements() -> Array:
	return type.advancements.get_children()


func get_effects() -> Array:
	return effects.get_children()


func get_counter_attack(attack: Attack) -> Attack:
	for counter in get_attacks():
		if counter.category == attack.category:
			return counter
	return null


func attach_unit_plate(plate: Node2D) -> void:
	ui_hook.remote_path = plate.get_path()


func get_defense(terrain_type: Array) -> int:
	if not terrain_type:
		return 0

	var defense : int = type.defense.get(terrain_type[0])
	if terrain_type.size() > 1:
		var defense_overlay : int = type.defense.get(terrain_type[1])
		defense = max(defense_overlay, defense)
	return defense


func get_resistance(damage_type: String) -> int:
	var resistance = type.resistance.get(damage_type)
	return resistance if resistance else 0


func get_movement_costs(terrain_type: Array) -> int:
	if not terrain_type:
		return 1

	var costs : int = type.movement.get(terrain_type[0])
	if terrain_type.size() > 1:
		var costs_overlay : int = type.movement.get(terrain_type[1])
		costs = max(costs, costs_overlay)
	return costs


func calculate_damage(damage: int, damage_type: String) -> int:
	return int(damage * (1 - float(get_resistance(damage_type)) / 100))


func can_attack() -> bool:
	return actions.value > 0


func is_dead() -> bool:
	return health.value == 0


func set_type(unit_type: UnitType, advancing := true) -> void:
	if advancing:
		remove_child(type)
		type.queue_free()
		type = null
		type = unit_type

	add_child(type)
	type.sprite.material = mat.duplicate()
	_load_race()
	reset()


func _load_race() -> void:
	if not Data.races.has(type.race):
		Console.warn("Race %s does not exist!" % type.race)

	race = Data.races[type.race]

	alias = race.get_random_name()


func _tween_hurt() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(type.sprite, "modulate", type.sprite.modulate, Color.red, 0.15, Tween.TRANS_SINE, Tween.EASE_IN)
	__ = tween.interpolate_property(type.sprite, "modulate", type.sprite.modulate, Color.white, 0.15, Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	__ = tween.start()


func _tween_heal() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(type.sprite, "modulate", type.sprite.modulate, Color.green, 0.15, Tween.TRANS_SINE, Tween.EASE_IN)
	__ = tween.interpolate_property(type.sprite, "modulate", type.sprite.modulate, Color.white, 0.15, Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	__ = tween.start()


func _tween_advancement_in() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(self, "brightness", 1.0, 2.2, 0.25, Tween.TRANS_SINE, Tween.EASE_IN)
	__ = tween.start()


func _tween_advancement_out() -> void:
	var __ = tween.stop_all()
	__ = tween.reset_all()
	__ = tween.interpolate_property(self, "brightness", 2.2, 1.0, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = tween.start()


func _set_is_leader(value: bool) -> void:
	is_leader = value

	if is_leader:
		upkeep = UpkeepType.FREE


func _set_brightness(value: float) -> void:
	brightness = value
	type.sprite.material.set_shader_param("brightness", value)

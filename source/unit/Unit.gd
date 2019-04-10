extends Node2D
class_name Unit

var side : Side = null

var health_current := 0
var moves_current := 0
var experience_current := 0

var location: Location = null setget _set_location

var path := []
var reachable := {} #setget _set_reachable
var viewable := {}

export(float, 0.1, 1.0) var move_time := 0.15

onready var tween := $Tween as Tween

var type : UnitType = null

func _ready() -> void:
	health_current = type.health
	moves_current = type.moves
	add_child(type)

func initialize(unit_type: UnitType) -> void:
	type = unit_type

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

func move_to(loc: Location) -> void:
	path = find_path(loc)
	_move()

func find_path(loc: Location) -> Array:
	if reachable.has(loc):
		return reachable[loc]
	return loc.map.find_path(location, loc)

func get_movement_cost(loc: Location) -> int:
	var cost =  type.movement.get(loc.terrain.type[0])
	if (loc.terrain.type.size() > 1):
		var cost_overlay = type.movement.get(loc.terrain.type[1])
		cost = max(cost_overlay, cost)
	return cost

func get_defense() -> int:
	var defense = type.defense.get(location.terrain.type[0])
	if location.terrain.type.size() > 1:
		var defense_overlay = type.defense.get(location.terrain.type[1])
		defense = max(defense_overlay, defense)
	return defense

func get_time_of_day_percentage() -> int:
	return location.terrain.time_of_day.get_percentage(type.alignment)

func set_reachable() -> void:
	viewable = location.map.find_all_viewable_cells(self)
	if moves_current == type.moves:
		reachable = viewable
		return
	reachable.clear()
	for key in viewable.keys():
		var cost = path_cost(viewable[key])
		if cost <= moves_current:
			reachable[key] = viewable[key]

func _move() -> void:
	if path and tween:
		var loc: Location = path[0]
		var cost = get_movement_cost(loc)

		if cost > moves_current:
			return

		location.unit = null
		location = loc
		location.unit = self

		#warning-ignore:return_value_discarded
		tween.interpolate_property(self, "position", position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

		if location.map.ZOC_tiles.has(location):
			moves_current = 0
		else:
			moves_current -= cost
		viewable = location.map.find_all_viewable_cells(self)
		set_reachable() # TODO: do we want this?
		path.remove(0)
		#warning-ignore:return_value_discarded
		tween.start()

func _grab_village() -> void:
	if location.terrain.gives_income:
		if side.add_village(location):
			moves_current = 0

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	Event.emit_signal("move_to", self, location)
	if path:
		_move()
	else:
		_grab_village()

func _set_location(value: Location) -> void:
	location = value
	set_reachable() # TODO: do we want this?

extends Node2D
class_name Unit

var side := 0

var health_current := 0
var moves_current := 0
var experience_current := 0

var location: Location = null

var unit_path := []
var viewable := {} #setget _set_reachable
var reachable := {}

export(float, 0.1, 1.0) var move_time := 0.15

onready var anim := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var tween := $Tween as Tween

onready var type := $Type as UnitType

func _ready() -> void:
	health_current = type.health
	moves_current = type.moves
	if anim.has_animation("idle"):
		anim.play("idle")

func place_at(loc: Location) -> void:
	if location:
		location.unit = null
	location = loc
	position = location.position
	location.unit = self

func move_to(loc: Location) -> void:
	# TODO: is it a problem that the unit isn't marked as being at every loc along the way?
	# BITRON: Might be, when simultaneous movement is allowed and two units have the same location as target for their movement.
	
	unit_path = find_path(loc)
	while (path_cost(unit_path) > moves_current):
		unit_path.pop_back()
		
	place_at(unit_path.back())

func find_path(loc: Location) -> Array:
	if reachable.has(loc):
		return reachable[loc]
	return loc.map.find_path(location, loc)

func path_cost(path: Array) -> int:
	var cost = 0
	for loc in path:
		cost += terrain_cost(loc)
	return cost

func terrain_cost(loc: Location) -> int:
	var cost =  type.movement.get(loc.terrain.type[0])
	if (loc.terrain.type.size() > 1):
		var cost_overlay = type.movement.get(loc.terrain.type[1])
		cost = max(cost_overlay, cost)
	return cost

func set_reachable() -> void:
	if viewable.empty():
		return
	if moves_current == type.moves:
		reachable = viewable
	else:
		for key in viewable.keys():
			var cur_path = viewable[key]
			var cost = 0
			for loc in cur_path:
				cost += terrain_cost(loc)
				if cost > moves_current:
					break
			if cost <= moves_current:
				reachable[key] = viewable[key]
func highlight_moves() -> void:
	for loc in reachable:
		location.map.cover.set_cellv(loc.cell, -1)
		location.map.fog.set_cellv(loc.cell, -1)
	location.map.cover.show()

func unhighlight_moves() -> void:
	var darken_id: int = location.map.tile_set.find_tile_by_name("Xv")
	for loc in reachable:
		location.map.cover.set_cellv(loc.cell, darken_id)
	location.map.cover.hide()

func _move() -> void:
	if unit_path and tween:
		var loc: Location = unit_path[0]

		location.unit = null
		location = loc
		location.unit = self

		#warning-ignore:return_value_discarded
		tween.interpolate_property(self, "position", position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

		unit_path.remove(0)
		#warning-ignore:return_value_discarded
		tween.start()

func _on_Tween_tween_completed(object, key):
	if unit_path and tween:
		_move()
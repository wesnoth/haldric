extends Node2D
class_name Unit

var side := 0

var current_health := 0
var current_moves := 0
var current_experience := 0


var data : Resource = null
var move_data : RMovement = null

var location: Location = null

var path := []
var reachable := {} setget _set_reachable

export(float, 0.1, 1.0) var move_time := 0.15

onready var sprite := $Sprite as Sprite
onready var tween := $Tween as Tween

func initialize(res: Resource) -> void:
	sprite.texture = res.base_image
	current_health = res.health
	current_moves = res.moves
	move_data = res.movement
	data = res

func place_at(loc: Location) -> void:
	if location:
		location.unit = null
	location = loc
	position = location.position
	location.unit = self

func move_to(loc: Location) -> void:
	if location:
		location.unit = null
	path = find_path(loc)
	_move()

func find_path(loc : Location) -> Array:
	#if reachable.has(loc):
	#	return reachable[loc]
	return loc.map.find_path(location,loc)

func terrain_cost(loc: Location) -> int:
	var cost =  move_data.get(loc.terrain.type[0])
	if (loc.terrain.type.size() > 1):
		var cost_overlay = move_data.get(loc.terrain.type[1])
		cost = max(cost_overlay, cost)
	return cost

func highlight_moves() -> void:
	for loc in reachable:
		location.map.cover.set_cellv(loc.cell, -1)
	location.map.cover.show()

func unhighlight_moves() -> void:
	var darken_id = location.map.tile_set.find_tile_by_name("darken")
	for loc in reachable:
		location.map.cover.set_cellv(loc.cell, darken_id)
	location.map.cover.hide()

func _move() -> void:
	if path and tween:
		var loc = path[0]

		location.unit = null
		location = loc
		location.unit = self

		#warning-ignore:return_value_discarded
		tween.interpolate_property(self, "position", position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

		path.remove(0)
		#warning-ignore:return_value_discarded
		tween.start()

func _set_reachable(value):
	reachable = value
	reachable[location] = location

func _on_Tween_tween_completed(object, key):
	if path and tween:
		_move()
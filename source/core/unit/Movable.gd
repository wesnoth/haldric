extends Node2D
class_name Movable

var location: Location = null

var path := []
var reachable := {}

var movement_points : int = 0
var move_data : RMovement = null

export(float, 0.1, 1.0) var move_time := 0.2

onready var tween := $Tween as Tween

func initialize(res : Resource) -> void:
	move_data = res.movement
	movement_points = res.moves

func place_at(loc: Location) -> void:
	if location:
		location.movable = null
	location = loc
	position = location.position
	location.movable = self

func move_to(loc: Location) -> void:
	if location:
		location.movable = null
	path = loc.map.find_path(location, loc)
	_move()

func terrain_cost(loc: Location) -> int:
	var cost =  move_data.get(loc.terrain.type[0])
	if (loc.terrain.type.size() > 1):
		var costOverlay = move_data.get(loc.terrain.type[1])
		cost = max(costOverlay, cost)
	return cost

func highlight_moves() -> void:
	var darken_id = location.map.tile_set.find_tile_by_name("darken")
	for cell in location.map.get_used_cells():
		if reachable.has(location.map.get_location(cell)):
			continue
		location.map.cover.set_cellv(cell, darken_id)

func unhighlight_moves() -> void:
	location.map.cover.clear()

func _move() -> void:
	if path and tween:
		var loc = path[0]
		
		location.movable = null
		location = loc
		location.movable = self
		
		#warning-ignore:return_value_discarded
		tween.interpolate_property(self, "position", position, loc.position,
				move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
		path.remove(0)
		#warning-ignore:return_value_discarded
		tween.start()

func _on_Tween_tween_completed(object, key):
	if path and tween:
		_move()

class_name Movable extends Node2D

var location : Location = null
var moveData : RMovement = null
var path := []
var reachable := {}
var movementPoints : int = 0

export(float, 0.1, 1.0) var move_time = 0.2

onready var tween = $Tween

func _move() -> void:
	if path and tween:
		var loc = path[0]

		location.movable = null
		location = loc
		location.movable = self

		tween.interpolate_property(self, "position", position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

		path.remove(0)
		tween.start()

func place_at(loc : Location) -> void:
	if self.location:
		self.location.movable = null
	self.location = loc
	self.position = location.position
	location.movable = self

func move_to(loc : Location) -> void:
	if self.location:
		self.location.movable = null
	path = loc.map.find_path(location, loc)
	_move()

func terrain_cost(loc : Location) -> int:
	var cost =  moveData.get(loc.terrain.type[0])
	if (loc.terrain.type.size() > 1):
		var costOverlay = moveData.get(loc.terrain.type[1])
		cost = max(costOverlay, cost)
	return cost

func highlight_moves():
	var darken_id = location.map.tile_set.find_tile_by_name("darken")
	for cell in location.map.get_used_cells():
		if reachable.has(location.map.get_location(cell)):
			continue
		location.map.cover.set_cellv(cell, darken_id)
func unhighlight_moves():
	location.map.cover.clear()

func _on_Tween_tween_completed(object, key):
	if path and tween:
		_move()

class_name Movable extends Node2D

var location : Location = null

var path := []

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

func _on_Tween_tween_completed(object, key):
	if path and tween:
		_move()

extends Node2D
class_name Movable

var location: Location = null

var path := []

export(float, 0.1, 1.0) var move_time := 0.2

onready var tween := $Tween as Tween

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

func _on_Tween_tween_completed(object, key):
	if path and tween:
		_move()

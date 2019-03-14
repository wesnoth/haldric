class_name Unit extends Node2D

var location := null

func move_to(loc) -> void:
	if self.location:
		self.location.unit = null
	self.location = loc
	self.position = location.position
	location.unit = self
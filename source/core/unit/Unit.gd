class_name Unit extends Node2D

var location = null

var side := 0

var sprite := Sprite.new()

func _ready():
	add_child(sprite)

func _init(res : Resource) -> void:
	sprite.texture = res.base_image

func move_to(loc) -> void:
	if self.location:
		self.location.unit = null
	self.location = loc
	self.position = location.position
	location.unit = self
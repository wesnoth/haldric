extends Movable
class_name Unit

var side := 0

onready var sprite := $Sprite as Sprite

func initialize(res: Resource) -> void:
	sprite.texture = res.base_image

extends Movable
class_name Unit

var side := 0
var data : Resource = null

onready var sprite := $Sprite as Sprite

func initialize(res: Resource) -> void:
	.initialize(res)
	sprite.texture = res.base_image
	data = res

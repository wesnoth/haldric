class_name Unit extends Movable

var side := 0
var data : Resource = null

onready var sprite = $Sprite

func initialize(res : Resource) -> void:
	.initialize(res)
	sprite.texture = res.base_image
	data = res

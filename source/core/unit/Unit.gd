class_name Unit extends Movable

var side := 0

onready var sprite = $Sprite

func initialize(res : Resource) -> void:
	sprite.texture = res.base_image
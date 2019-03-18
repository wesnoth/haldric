class_name Location

const OFFSET = Vector2(36, 36)

var id := 0

var cell := Vector2()
var position := Vector2()

var map = null
var movable = null
var terrain : Terrain = null

var is_blocked := false

func get_position_centered() -> Vector2:
	return position + OFFSET

class_name Location

const OFFSET = Vector2(36, 36)

var id := 0

var position := Vector2()
var cell := Vector2()

# "map" and "unit" can't be typed because of cyclic recursion.
var map = null
var unit = null

var terrain: Terrain = null

var is_blocked := false

var flag = null

func get_position_centered() -> Vector2:
	return position + OFFSET

class_name Location

const OFFSET = Vector2(36, 36)

var id := ""

var cell := Vector2()
var position := Vector2()

var terrain := null
var unit := null

func get_position_centered() -> Vector2:
	return position + OFFSET
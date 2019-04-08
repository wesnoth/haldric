extends Node2D
class_name Location

const OFFSET = Vector2(36, 36)

const Flag = preload("res://source/game/Flag.tscn")

var id := 0

var cell := Vector2()

# "map" and "unit" can't be typed because of cyclic recursion.
var map = null
var unit = null

var terrain: Terrain = null

var is_blocked := false

var flag = null

func get_position_centered() -> Vector2:
	return position + OFFSET

func add_flag(side: int, flag_shader: ShaderMaterial):
	if not flag:
		flag = Flag.instance()
		flag.side = side
		# flag.material = flag_shader
		add_child(flag)

func remove_flag():
	if flag:
		flag.queue_free()
		flag = null



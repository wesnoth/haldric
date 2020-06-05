extends Resource
class_name MapData

export var data : Dictionary = {}

func create(width: int, height: int, code: Array) -> void:
	for y in height:
		for x in width:
			data[Vector2(x, y)] = code

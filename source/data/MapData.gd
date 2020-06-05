extends Resource
class_name MapData

export var width := 0
export var height := 0

export var players : Dictionary
export var data : Dictionary

func create(_width: int, _height: int, code: Array) -> void:
	data = {}
	players = {}
	width = _width
	height = _height

	for y in height:
		for x in width:
			data[Vector2(x, y)] = code

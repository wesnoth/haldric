extends Node

static func flatten(vec: Vector2, magnitude: int) -> int:
	return int(vec.y) * magnitude + int(vec.x)

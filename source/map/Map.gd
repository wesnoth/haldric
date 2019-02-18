class_name Map extends TileMap

const OFFSET = Vector2(36, 36)

var width := 0
var height := 0

var locations := []

func _ready():
	_initialize_locations()
	width = get_used_rect().size.x
	height = get_used_rect().size.y

func map_to_world_centered(cell : Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world_centered(world_to_map(cell))

func _initialize_locations() -> void:
	for y in range(height):
		for x in range (width):
			var cell := Vector2(x, y)
			var id := _flatten(cell)
			var loc := Location.new()
			loc.id = id
			loc.cell = Vector2(x, y)
			loc.position = map_to_world(cell)
			locations[id] = loc

func _flatten(cell : Vector2) -> int:
	return int(cell.y) * int(width) + int(cell.x)
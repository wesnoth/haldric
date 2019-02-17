class_name Map extends TileMap

var width := 0
var height := 0

var locations := []

func _ready():
	width = get_used_rect().size.x
	height = get_used_rect().size.y

func map_to_world_centered(cell : Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func _initialize_locations():
	for y in range(height):
		for x in range (width):
			var cell = Vector2(x, y)
			var id = _flatten(cell)
			var loc = Location.new()
			loc.id = id
			loc.cell = Vector2(x, y)
			loc.position = map_to_world(cell)
			locations[id] = Location.new(self, cell)

func _flatten(cell):
	return int(cell.y) * int(width) + int(cell.x)
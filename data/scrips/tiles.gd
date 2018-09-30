extends TileMap

export (int) var WIDTH = 20
export (int) var HEIGHT = 10

var tiles = {}

func _ready():
	_generate_tiles()


# P U B L I C   F U N C T I O N S


func flatten_v(_cell):
	return int(_cell.y) * WIDTH + int(_cell.x)

func flatten(_x, _y):
	return int(_y) * WIDTH + int(_x)

func check_boundaries(_point):
	return (_point.x >= 0 and _point.y >= 0 and _point.x < WIDTH  and _point.y < HEIGHT)


# P R I V A T E   F U N C T I O N S


func _generate_tiles():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var cell = Vector2(x, y)
			var id = flatten_v(cell)
			tiles[id] = {
					cell = cell,
					type = get_cell(cell.x, cell.y),
					weight = 1,
					is_blocked = false,
			}
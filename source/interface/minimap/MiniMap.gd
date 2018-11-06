extends Control

var map_size = Vector2(0,0)
var tiles = {}

var colors = {
	flat = "a8d394",
	village = "ce8a25",
	hills = "bac452",
	forest = "658426",
	mountains = "e3e5ce"
}
func _process(delta):
	update()

func _draw():
	var color = "FFFFFF"
	for y in range(map_size.y):
		for x in range(map_size.x):
			if colors.has(tiles[y * map_size.x + x].terrain_type[1]):
				color = colors[tiles[y * map_size.x + x].terrain_type[1]]
			elif colors.has(tiles[y * map_size.x + x].terrain_type[0]):
				color = colors[tiles[y * map_size.x + x].terrain_type[0]]
			else:
				color = "FFFFFF"
			draw_circle(Vector2(6 * x + 1, 8 * y + 1), 5, color)
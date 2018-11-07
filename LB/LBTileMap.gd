extends TileMap

var SHADER = preload("res://LB/tile.shader")

var MASK = preload("res://LB/mask.png")

var details = [
	preload("res://LB/Test_grass_decal1.png"),
	preload("res://LB/Test_grass_decal2.png"),
	preload("res://LB/Test_grass_decal3.png")
]

func _ready():
	for cell in get_used_cells():
		var pos = map_to_world(cell)
		var random1 = randi() % 12
		var random2 = randi() % 12
		if random1 < 3:
			var tex = details[random1]
			add_detail(tex, pos)
		if random2 < 3 and random1 > random2:
			var tex = details[random2]
			add_detail(tex, pos)
func add_detail(tex, pos):
	var sprite = Sprite.new()
	sprite.centered = false
	sprite.texture = tex
	sprite.position = pos
	add_child(sprite)
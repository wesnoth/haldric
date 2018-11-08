extends TileMap

export (int, 0, 100) var offset_range = 60
export (float, 0, 2.99) var decals = 0.5

var SHADER = preload("res://LB/tile.shader")
var MASK = preload("res://LB/mask.png")

var DETAILS = [
	preload("res://LB/Test_grass_decal1.png"),
	preload("res://LB/Test_grass_decal2.png"),
	preload("res://LB/Test_grass_decal3.png")
]

var string 

onready var detail_container = $"Details"

func _ready():
	randomize()
	
	for cell in get_used_cells():
		var pos = map_to_world(cell)
		var used = []
		for i in range(int(decals) + 1):
			var rand = randf() + i
			string = str(i + 1, " » ", rand)
			var decal = randi() % 3
			if rand < decals and not decal in used:
				string += str(", decal set")
				var tex = DETAILS[decal]
				used.append(decal)
				add_detail(tex, pos)
			print(string)
			
func add_detail(tex, pos):
	var sprite = Sprite.new()
	var offset = Vector2(0, 0)
	
	offset.x = ((randi() % (offset_range + 1)) - offset_range / 2) * 2
	offset.y = ((randi() % (offset_range + 1)) - offset_range / 2) * 2
	
	pos += offset
	
	sprite.centered = false
	sprite.texture = tex
	sprite.position = pos
	
	detail_container.add_child(sprite)
	string += str(", offset: ", offset)
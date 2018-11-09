extends TileMap

export (bool) var use_map_size = false 
export (Vector2) var map_size = Vector2(40, 40)
export (bool) var use_layers = false
export (int) var random_seed = 1
export (float, 0, 0.99) var flip = 0.5

var SHADER = preload("res://LB/tile.shader")
var MASK = preload("res://LB/mask.png")

var decals = {}

var string 

onready var detail_container = $"Details"

# this is only to get the camera from Game.gd working without having to change its code
onready var terrain = self

onready var layers = [
	$"Layer0",
	$"Layer1",
	$"Layer2",
	$"Layer3",
	$"Layer4",
]

func _ready():
	if use_map_size:
		generate_map()
	_load_decal_dir("res://LB/decals/json")
	generate_tile_set()
	
	seed(random_seed)
	
	if use_layers:
		use_tile_set()
	else:
		use_sprites()

func use_tile_set():
	for cell in get_used_cells():
		for decal in decals.values():
			if randf() < decal.probability:
				layers[decal.layer].set_cellv(cell + Vector2(1, 1), decal.index)

func use_sprites():
	for cell in get_used_cells():
		var used = []
		for decal in decals.values():
			decal["pos"] = Vector2(0,0)
			decal.pos = map_to_world(cell)
			if randf() < decal.probability and !used.has(decal):
				add_detail(decal)
				used.append(decal)

func add_detail(decal):
	var sprite = null
	
	if decal.has("image"):
		sprite = Sprite.new()
		sprite.texture = decal.image
	
	if decal.has("animation"):
		sprite = AnimatedSprite.new()
		sprite.frames = decal.frames
		sprite.play("default")
		
	var offset = Vector2(0, 0)
	var scale = Vector2(0, 0)

	offset.x = decal.offset.x + ((randi() % (int(decal.placement_range.x) + 1)) - decal.placement_range.x / 2) * 2
	offset.y = decal.offset.y + ((randi() % (int(decal.placement_range.y) + 1)) - decal.placement_range.y / 2) * 2

	scale = rand_range(decal.scale_range.min, decal.scale_range.max)

	decal.pos += offset

	if randf() < flip:
		sprite.flip_h = true
	sprite.centered = true
	sprite.position = decal.pos
	sprite.scale = Vector2(scale, scale)
	sprite.z_index = decal.layer
	detail_container.add_child(sprite)

func generate_tile_set():
	var index = 0
	var tileset = TileSet.new()
	for decal in decals.values():
		decal["index"] = index;
		tileset.create_tile(index)
		tileset.tile_set_texture(index, decal.image)
		tileset.tile_set_region(index, Rect2(Vector2(0,0), decal.image.get_size()))
		index += 1
	for layer in layers:
		layer.tile_set = tileset

func generate_map():
	for y in range(map_size.y):
		for x in range(map_size.x):
			set_cell(x, y, 0)

func _load_decal_dir(path):
	var files = []
	files = Registry.get_files_in_directory(path, files)
	for file in files:
		var config = JSON.parse(file.data.get_as_text()).result
		decals[file.id] = config
		decals[file.id].id = file.id
		
		if config.has("image"):
			config.image = load(config.image)
		
		if config.has("animation"):
			var frames = SpriteFrames.new()
			for i in range(config.animation.frames.size()):
				var tex = load(config.animation.frames[i])
				frames.add_frame("default", tex, i)
			frames.set_animation_speed("default", config.animation.fps)
			frames.set_animation_loop("default", true)
			decals[file.id].frames = frames
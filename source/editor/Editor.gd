extends Node2D

onready var HUD = $HUD
onready var map = $Map

var current_tile = 0

func _process(delta) -> void:
	if Input.is_action_pressed("mouse_left"):
		var mouse_position = get_global_mouse_position()
		map.set_tile(mouse_position, current_tile)

func _ready() -> void:
	for id in map.tile_set.get_tiles_ids():
		_add_terrain_button(id)

func _add_terrain_button(id : int) -> void:
	var button = TextureButton.new()
	button.connect("pressed", self, "_on_button_pressed", [ id ])
	var texture = AtlasTexture.new()
	texture.atlas = map.tile_set.tile_get_texture(id)
	texture.region = map.tile_set.tile_get_region(id)
	button.texture_normal = texture
	button.rect_size = Vector2(54, 72)
	HUD.add_button(button)

func _on_button_pressed(id):
	print(id)
	current_tile = id

func _on_Back_pressed():
	Scene.change(Scene.TitleScreen)
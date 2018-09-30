extends Control

onready var map = $"../../TileMap"
onready var selector = $"Selector"

func _process(delta):
	var cell = map.world_to_map(get_global_mouse_position())
	selector.position = map.map_to_world(cell)
	if map.check_boundaries(cell):
		$Selector/TileCoords.text = str(map.tiles[map.flatten_v(cell)].cell)
		$Selector/TileType.text = str(map.tiles[map.flatten_v(cell)].type)
		

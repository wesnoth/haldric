extends Control

onready var map = $"../../Bottom"
onready var selector = $"Selector"

func _process(delta):
	var cell = map.world_to_map(get_global_mouse_position())
	selector.position = map.map_to_world(cell)
	$Selector/TileCoords.text = str(cell)

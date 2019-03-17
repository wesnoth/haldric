extends TileMap

onready var overlay = $Overlay
onready var cover = $Cover

func set_tile(global_position, id):
	var cell = world_to_map(global_position)
	set_cellv(cell, id)
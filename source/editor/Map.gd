extends TileMap

onready var overlay = $Overlay
onready var cover = $Cover

func set_tile(global_position, id):
	var cell = world_to_map(global_position)
	var code = tile_set.tile_get_name(id)
	if code.begins_with("^"):
		overlay.set_cellv(cell, id)
	else:
		set_cellv(cell, id)

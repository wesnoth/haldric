extends TileMap

onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap

func set_tile(global_pos: Vector2, id: int) -> void:
	var cell = world_to_map(global_pos)
	var code = tile_set.tile_get_name(id)
	if code.begins_with("^"):
		overlay.set_cellv(cell, id)
	else:
		set_cellv(cell, id)

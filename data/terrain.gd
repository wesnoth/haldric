extends TerrainLoader

func _load() -> void:
	add_basic_terrain("Grass", "Gg", "flat", "grass.png")
	add_basic_terrain("Hills", "Hh", "hills", "hills.png")
	add_basic_terrain("Mountain", "Mm", "mountains", "mountain.png")
	add_basic_terrain("Water", "Ww", "water", "water/water_animated.tres")

	add_large_terrain("Forest", "^F", "forest", "forest.png")

	add_village_terrain("Village", "^Vh", "village", "village.png")

	add_keep_terrain("Keep", "Kh", "castle", "keep-tile.png")

	add_castle_terrain("Castle", "Ch", "castle", "castle-tile.png")

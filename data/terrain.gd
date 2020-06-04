extends TerrainLoader

func _load() -> void:
	add_basic_terrain("Grass", "Gg", "grass.png")
	add_basic_terrain("Hills", "Hh", "hills.png")
	add_basic_terrain("Mountain", "Mm", "mountain.png")
	add_basic_terrain("Water", "Ww", "water/water_animated.tres")

	add_large_terrain("Forest", "^F", "forest.png")

	add_village_terrain("Village", "^Vh", "village.png")

	add_keep_terrain("Keep", "Kh", "keep-tile.png")

	add_castle_terrain("Castle", "Ch", "castle-tile.png")

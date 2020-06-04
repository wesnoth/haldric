extends TerrainLoader

func _load() -> void:
	add_basic_terrain("Grass", "G", "grass.png")
	add_basic_terrain("Hills", "H", "hills.png")
	add_basic_terrain("Mountain", "M", "mountain.png")
	add_basic_terrain("Forest", "^F", "forest.png")
	add_basic_terrain("Water", "Ww", "water/water_animated.tres")

	add_village_terrain("Village", "^V", "village.png")

	add_keep_terrain("Keep", "K", "keep-tile.png")

	add_castle_terrain("Castle", "C", "castle-tile.png")

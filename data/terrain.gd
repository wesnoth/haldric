extends TerrainLoader

func _load() -> void:
	new_base("Grass", "Gg", "flat", "grass/green")
	new_base("Hills", "Hh", "hills", "hills")
	new_base("Mountain", "Mm", "mountains", "mountain")
	new_base("Water", "Ww", "water", "water/water_animated", "tres")
	new_base("Forest", "^F", "forest", "forest", "png", Vector2(-36, -36))

	new_village("Village", "^Vh", "village", "village")

	new_keep("Keep", "Kh", "castle", "keep-tile")

	new_castle("Castle", "Ch", "castle", "castle-tile")

	# PREVIEW, NOT WORKING YET
	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "grass/grass")

extends TerrainLoader

func _load() -> void:
	open_path("res://graphics/images/terrain/")

	new_base("Grass", "Gg", -20, "flat", "green")
	new_base("Hills", "Hh", 100, "hills", "regular")
	new_base("Mountain", "Mm", 200, "mountains", "mountain")
	new_base("Water", "Ww", -100, "water", "water_animated")

	new_overlay("Forest", "^F", "forest", "forest", Vector2(-36, -36))

	new_village("Village", "^Vh", "village", "village")

	new_keep("Keep", "Kh", "castle", "keep-tile")

	new_castle("Castle", "Ch", "castle", "castle-tile")

	# PREVIEW, NOT WORKING YET
	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "green")
	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "green", "medium")
	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "green", "abrupt")
	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "green", "long")

	new_transition("Hh", [], [], "regular")

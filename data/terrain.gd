extends TerrainLoader

func _load() -> void:
	open_path("res://graphics/images/terrain/")

	new_base("GreenGrass", "Gg", -20, "flat", "green")
	new_base("Hills", "Hh", 100, "hills", "regular")
	new_base("Water", "Ww", -100, "water", "water_animated")

	new_base("Mountains", "Mm", 200, "mountains", "basic", Vector2(-56, -68))

	new_overlay("Forest", "^F", "forest", "forest", Vector2(-36, -36))

	new_village("Village", "^Vh", "village", "village")

	new_keep("Keep", "Kh", "castle", "keep-tile")

	new_castle("Castle", "Ch", "castle", "castle-tile")

	new_transition("Gg", ["Gs", "Gd", "Gll"], [], "green")
	new_transition("Gg", ["Ww"], [], "bank-to-ice")

	new_transition("Mm", [], [], "basic")

	new_transition("Hh", [], [], "regular")
	new_transition("Hh", ["Ww"], ["Gg"], "regular", "to-water")

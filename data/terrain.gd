extends TerrainLoader

func _load() -> void:
	open_path("res://graphics/images/terrain/")

	new_base("Beach", "Ds", -200, "sand", "sand/beach")
	new_base("Water", "Ww", -100, "water", "water/animated")
	new_base("Grass", "Gg", -20, "flat", "grass/green")
	new_base("Hills", "Hh", 100, "hills", "hills/regular")

	new_base("Mountains", "Mm", 200, "mountains", "mountains/basic", Vector2(-56, -68))

	new_overlay("Forest", "^F", "forest", "forest", Vector2(-36, -36))

	new_village("Village", "^Vh", "village", "village")

	new_keep("Keep", "Kh", "castle", "keep-tile")

	new_castle("Castle", "Ch", "castle", "castle-tile")

	new_transition("Gg", [], ["Ww", "Ds"], "grass/green")
	new_transition("Gg", ["Ds"], [], "grass/green-medium")
	new_transition(["Gg", "Hh"], ["Ww"], [], "flat/bank")
	new_transition("Gg", ["Ww"], [], "cave/bank")
	new_transition("Gg", ["Ww"], [], "grass/green-abrupt")

	new_transition("Mm", [], [], "mountains/basic")

	new_transition("Hh", [], ["Ww"], "hills/regular")
	new_transition("Hh", ["Ww"], [], "hills/regular-to-water")

	new_transition("Ww", ["Ds"], [], "water/animated")

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

	new_castle("Castle", "Ch", "castle", "flat/road-clean")

	new_transition("Gg", [], ["Ww", "Ds", "Ch"], "grass/green")
	new_transition("Gg", ["Ds"], [], "grass/green-medium")
	new_transition(["Gg", "Hh"], ["Ww"], [], "flat/bank")
	new_transition("Gg", ["Ww"], [], "cave/bank")
	new_transition("Gg", ["Ww"], [], "grass/green-abrupt")

	new_transition("Mm", [], ["Ch"], "mountains/basic")

	new_transition("Hh", [], ["Ww","Ch"], "hills/regular")
	new_transition("Hh", ["Ww"], [], "hills/regular-to-water")

	new_transition("Ww", ["Ds"], [], "water/animated")

	new_castle_wall_tower("Ch", [], ["Kh"], "castle/castle-tower", Vector2(-10, -34))

	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "n", Vector2(26, 59))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "ne", Vector2(-2, 25))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "se", Vector2(-12, -3))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "s", Vector2(29, -16))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "sw", Vector2(54, -16))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "nw", Vector2(40, 25))

extends TerrainLoader


func _load() -> void:
	open_path("res://graphics/images/terrain/")

	new_base("Beach", "Ds", -200, ["sand"], "sand/beach")
	new_base("Grass", "Gg", -20, ["flat"], "grass/green")
	new_base("Hills", "Hh", 100, ["hills"], "hills/regular")
	new_base("Cave Floor", "Uu", 100, ["cave"], "cave/floor")
	new_base("Rockbound Cave", "Uh", 100, ["cave", "hills"], "cave/hills")
	new_base("Ice", "Ai", -50, ["frozen"], "frozen/ice")
	new_base("Snow", "Aa", -40, ["frozen"], "frozen/snow")
	new_base("Swamp", "Ss", -90, ["swamp"], "swamp/water")
	new_base("Water", "Ww", -100, ["water"], "water/animated")
	new_base("Coastal Reef", "Wwrg", -100, ["water"], "water/animated")
	new_base("Mud", "Sm", -110, ["swamp"], "swamp/mud")

	new_base("Mountains", "Mm", 200, ["mountains"], "mountains/basic", Vector2(-56, -68))

	new_overlay("Forest", "^F", ["forest"], "forest", Vector2(-36, -36))

	new_village("Village", "^Vh", ["village"], "village")

	new_keep("Keep", "Kh", ["castle"], "keep-tile")

	new_castle("Castle", "Ch", ["castle"], "flat/road-clean")

	new_decoration("Ss", "swamp/reed", Vector2(-22, -25))
	new_decoration("Wwrg", "water/reef")

	new_transition("Gg", [], ["Ww", "Wwrg", "Ds", "Ch"], "grass/green")
	new_transition("Gg", ["Ds"], [], "grass/green-medium")
	new_transition(["Gg", "Hh", "Mm"], ["Ww"], [], "flat/bank")
	new_transition("Gg", ["Ww", "Wwrg", "Ai"], [], "cave/bank")
	new_transition("Gg", ["Ww", "Wwrg", "Ai"], [], "grass/green-abrupt")

	new_transition(["Ai"], ["Ww", "Wwrg", "Ds"], [], "frozen/ice")

	new_transition("Aa", [], ["Ww", "Wwrg"], "frozen/snow")
	new_transition("Aa", ["Ww", "Wwrg"], [], "frozen/snow-to-water")

	new_transition(["Ai", "Aa"], ["Ww", "Wwrg"], [], "frozen/ice-to-water")

	new_transition("Mm", [], ["Ch", "Ww", "Wwrg"], "mountains/basic")

	new_transition("Hh", [], ["Ww", "Wwrg", "Ch"], "hills/regular")
	new_transition(["Hh", "Mm"], ["Ww", "Wwrg", "Ai"], [], "hills/regular-to-water")

	new_transition("Uh", [], ["Hh", "Ch", "Mm"], "cave/hills")
	new_transition("Uu", [], ["Uh", "Hh", "Ch", "Mm"], "cave/floor")

	new_transition("Ww", ["Ds", "Sm"], [], "water/animated")
	new_transition("Wwrg", ["Ds", "Sm"], [], "water/animated")

	new_transition("Ss", ["Ds", "Sm", "Ww", "Wwrg"], [], "swamp/water")

	new_transition("Sm", ["Ds"], [], "swamp/mud-to-land")


	new_castle_wall_tower("Ch", [], ["Kh"], "castle/castle-tower", Vector2(-10, -34))

	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "n", Vector2(26, 57))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "ne", Vector2(-3, 26))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "se", Vector2(-14, -8))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "s", Vector2(26, -15))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "sw", Vector2(52, -10))
	new_castle_wall_segment("Ch", [], ["Kh"], "castle/castle", "nw", Vector2(39, 27))

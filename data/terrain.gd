extends TerrainLoader


func _load() -> void:
	open_path("res://assets/graphics/images/terrain/")

	new_base("Beach", "Ds", -200, ["sand"], "sand/beach")
	new_base("Green Grass", "Gg", -20, ["flat"], "grass/green")
	new_base("Semyi-Dry Grass", "Gs", -20, ["flat"], "grass/semi-dry")
	new_base("Dry Grass", "Gd", -20, ["flat"], "grass/dry")
	new_base("Leaf Litter", "Gll", -20, ["flat"], "grass/leaf-litter")
	new_base("Hills", "Hh", 100, ["hills"], "hills/regular")
	new_base("Cave Floor", "Uu", 100, ["cave"], "cave/floor")
	new_base("Rockbound Cave", "Uh", 100, ["cave", "hills"], "cave/hills")
	new_base("Ice", "Ai", -50, ["frozen"], "frozen/ice")
	new_base("Snow", "Aa", -40, ["frozen"], "frozen/snow")
	new_base("Swamp", "Ss", -90, ["swamp"], "swamp/water")
	new_base("Water", "Ww", -100, ["deep_water"], "water/animated")
	new_base("Coastal Reef", "Wwrg", -100, ["coastal_reef"], "water/animated")
	new_base("Mud", "Sm", -110, ["swamp"], "swamp/mud")

	new_base("Mountains", "Mm", 200, ["mountains"], "mountains/basic", Vector2(-56, -68))

	new_overlay("Forest", "^F", ["forest"], "forest", Vector2(-36, -36))

	new_village("Village", "^Vh", ["village"], "village")

	new_keep("Keep", "Kh", ["castle"], "keep-tile")

	new_castle("Castle", "Ch", ["castle"], "flat/road-clean")

	new_base_overlay("Wwrg", "water/reef")

	new_decoration("Ss", "swamp/reed", Vector2(-22, -25))

	new_transition(["Gg", "Gs", "Gd", "Gll", "Hh", "Mm"], ["Ww"], [], "flat/bank")
	new_transition(["Gg", "Gs", "Gd", "Gll"], ["Ww", "Wwrg", "Ai"], [], "cave/bank")

	new_transition(["Gg"], ["Ww", "Wwrg", "Ai"], [], "grass/green-abrupt")
	new_transition(["Gs"], ["Ww", "Wwrg", "Ai"], [], "grass/semi-dry-abrupt")
	new_transition(["Gd"], ["Ww", "Wwrg", "Ai"], [], "grass/dry-abrupt")
	new_transition(["Gll"], ["Ww", "Wwrg", "Ai"], [], "grass/leaf-litter-abrupt")

	new_transition(["Gg"], ["Ds"], [], "grass/green-medium")
	new_transition(["Gs"], ["Ds"], [], "grass/semi-dry-medium")
	new_transition(["Gd"], ["Ds"], [], "grass/dry-medium")
	new_transition(["Gll"], ["Ds"], [], "grass/leaf-litter-medium")

	new_transition("Gg", [], ["Ww", "Wwrg", "Ds", "Ch", "Gs", "Gd", "Gll"], "grass/green")
	new_transition("Gs", [], ["Ww", "Wwrg", "Ds", "Ch", "Gg", "Gd", "Gll"], "grass/semi-dry")
	new_transition("Gd", [], ["Ww", "Wwrg", "Ds", "Ch", "Gs", "Gg", "Gll"], "grass/dry")
	new_transition("Gll", [], ["Ww", "Wwrg", "Ds", "Ch", "Gs", "Gd", "Gg"], "grass/leaf-litter")

	new_transition("Gg", ["Gd", "Gs", "Gll"], [], "grass/green-long")
	new_transition("Gs", ["Gd", "Gg", "Gll"], [], "grass/semi-dry-long")
	new_transition("Gd", ["Gg", "Gs", "Gll"], [], "grass/dry-long")
	new_transition("Gll", ["Gd", "Gs", "Gg"], [], "grass/leaf-litter-long")

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

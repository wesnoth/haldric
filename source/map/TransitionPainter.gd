extends Node2D
class_name TransitionPainter

const directions = [  "n", "ne", "se", "s", "sw", "nw"]

var locations := {}

func _draw() -> void:
	for cell in locations:
		var loc : Location = locations[cell]
		set_location_transition(loc)


func set_location_transition(loc: Location) -> void:
	var code = loc.terrain.get_base_code()

	var direction := 0
	for n_loc in loc.get_all_neighbors():

		if not n_loc or n_loc.terrain.get_base_code() == code or loc.terrain.layer >= n_loc.terrain.layer:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if not Data.transitions.has(n_code):
			direction += 1
			continue

		var n_data = Data.transitions[n_code]

		for g in n_data:

			var n_graphic : TerrainTransitionGraphicData = g

			if n_graphic.exclude.has(code):
				continue

			elif not n_graphic.include or n_graphic.include.has(code):
				var transition_name = "-" + directions[direction]

				if not n_graphic.textures.has(transition_name):
					continue

				draw_texture(n_graphic.textures[transition_name], loc.position - Vector2(36, 36))

		direction += 1


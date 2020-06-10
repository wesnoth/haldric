extends Node2D
class_name TerrainPainter

const directions = [  "n", "ne", "se", "s", "sw", "nw"]

var RNG = RandomNumberGenerator.new()

var locations := {}

func _draw() -> void:
	RNG = RandomNumberGenerator.new()
	RNG.seed = 10

	for cell in locations:
		var loc : Location = locations[cell]
		_set_location_base(loc)
		_set_location_transition(loc)
		_set_location_overlay(loc)


func _set_location_base(loc: Location) -> void:

	var data : TerrainData = Data.terrains[loc.terrain.get_base_code()]

	if not data.graphic.variations:
		draw_texture(data.graphic.texture, loc.position - Hex.OFFSET + data.graphic.offset)
		return

	var variations = data.graphic.get_textures()

	draw_texture(variations[RNG.randi() % variations.size()], loc.position - Hex.OFFSET + data.graphic.offset)


func _set_location_overlay(loc: Location) -> void:

	if not Data.terrains.has(loc.terrain.get_overlay_code()):
		return

	var data : TerrainData = Data.terrains[loc.terrain.get_overlay_code()]

	if not data.graphic.variations:
		draw_texture(data.graphic.texture, loc.position - Hex.OFFSET + data.graphic.offset)
		return

	var variations = data.graphic.get_textures()

	draw_texture(variations[RNG.randi() % variations.size()], loc.position - Hex.OFFSET + data.graphic.offset)


func _set_location_transition(loc: Location) -> void:
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

				draw_texture(n_graphic.textures[transition_name], loc.position - Hex.OFFSET)

		direction += 1


extends Node2D

const void_texture_offset = Vector2(108, 108)
const void_texture = preload("res://graphics/images/terrain/fog-uncover.png")

var units := []
var side_number: int = 0

func _draw() -> void:
	draw_rect(get_viewport_rect(), Color("000000"))

	if not units:
		return

	# Since the map is fogged, start by hiding all units.
	for unit in units:
		unit.visible = false

	# Then, iterate over all all units beloning to the current side (TODO: handle allied vision)
	for unit in units:
		if unit.side.number != side_number:
			continue;

		# Take each of the hexes it can view...
		for viewable in unit.viewable:
			# ...mask out the fog...
			draw_texture(void_texture, viewable.position - void_texture_offset)

			# ...and make any unit in that area visible.
			if viewable.unit:
				viewable.unit.visible = true

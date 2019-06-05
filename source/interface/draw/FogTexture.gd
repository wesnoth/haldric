extends Node2D

const void_texture_offset = Vector2(108, 108)
const void_texture = preload("res://graphics/images/terrain/fog-uncover.png")

var units := []
var side_number: int = 0
var side = null

func _draw() -> void:
	draw_rect(get_viewport_rect(), Color("000000"))

	if not units:
		return
	
	if not side.fog:
		for unit in units:
			unit.visible = true
		return
	# Since the map is fogged, start by hiding all units.
	for unit in units:
		unit.visible = false

	# Then, iterate over all ox the viewable hexes beloning to the current side (TODO: handle allied vision)
	for viewable in side.viewable:
		draw_texture(void_texture, viewable.position - void_texture_offset)
		if viewable.unit:
			viewable.unit.visible = true

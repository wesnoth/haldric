extends Node2D

var void_texture = preload("res://graphics/images/terrain/fog-uncover.png")

var units
var side
func _process(delta: float) -> void:
	units = get_tree().get_nodes_in_group("Unit")

	update()

func _draw() -> void:
	draw_rect(get_viewport_rect(), Color("000000"))

	if units:
		for unit in units:
			if unit.side.number == side:
				for viewable in unit.viewable:
					draw_texture(void_texture, viewable.position)
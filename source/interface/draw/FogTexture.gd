extends Node2D

var void_texture = preload("res://graphics/images/terrain/fog-uncover.png")

var units
var side

func _process(delta: float) -> void:
	update()

func _draw() -> void:
	draw_rect(get_viewport_rect(), Color("000000"))

	if units:
		for unit in units:
			unit.visible = false

		for unit in units:
			if unit.side.number == side:
				unit.visible = true
				for viewable in unit.viewable:
					draw_texture(void_texture, viewable.position)
					if viewable.unit:
						viewable.unit.visible = true
extends Node2D

onready var grid_container = $"GridContainer"
onready var darken_container = $"DarkenContainer"

var tex_darken = preload("res://interface/images/darken.png")
var tex_grid = preload("res://interface/images/grid.png")


func show_darken(terrain, reachable):
	var darken_id = terrain.tile_set.find_tile_by_name("darken")
	
	for cell in terrain.get_used_cells():
		if cell in reachable:
			continue
		terrain.cover.set_cellv(cell, darken_id)

func show_grid(terrain):
	for p in terrain.grid.get_points():
		var p_cell = terrain.grid.get_point_position(p)
		_add_marker(grid_container, tex_grid, terrain.map_to_world_centered(Vector2(p_cell.x, p_cell.y)))


func remove_darken(terrain):
	terrain.cover.clear()

func remove_grid():
	_clear_container(grid_container)


func _add_marker(container, texture, pos):
	var marker = Sprite.new()
	marker.texture = texture
	marker.position = pos
	container.add_child(marker)

func _clear_container(container):
	for child in container.get_children():
		child.queue_free()
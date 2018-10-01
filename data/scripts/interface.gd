extends Node2D

onready var cursor = $Cursor
onready var terrain = $"../Terrain"

var show_grid = false

func _input(event):
	if event and Input.is_action_just_pressed("toggle_grid"):
		show_grid = !show_grid

func _process(delta):
	update()
	cursor.position = terrain.world_to_world_centered(get_global_mouse_position())
	
func _draw():
	# DRAW REACHABLE CELLS
	for p in terrain.get_reachable_cells_u(terrain.unit):
		var pos = terrain.map_to_world_centered(p)
		draw_circle(pos, 5, Color(255, 255, 255))
	
	# DRAW PATH
	for n in range(terrain.path.size()):
		draw_circle(terrain.map_to_world_centered(terrain.path[n]), 5, Color(255, 0, 0))
	
	# DRAW CONNECTIONS
	if show_grid:
		var points = terrain.grid.get_points()
		for p in points:
			var p_pos = terrain.grid.get_point_position(p) * Vector3(54, 72, 0) + Vector3(36, 36, 0)
			if int(terrain.tiles[p].cell.x) % 2 == 1:
				p_pos += Vector3(0, 36, 0)
			var neighbors = terrain.grid.get_point_connections(p)
			for n in neighbors:
				var n_cell = terrain.grid.get_point_position(n)
				var n_pos = n_cell * Vector3(54, 72, 0) + Vector3(36, 36, 0)
				if int(n_cell.x) & 1 == 1:
					n_pos += Vector3(0, 36, 0)
				draw_line(Vector2(p_pos.x, p_pos.y), Vector2(n_pos.x, n_pos.y), Color(255, 0, 0), 1)

extends Node2D

onready var cursor = $Cursor
onready var terrain = $"../Terrain"

func _process(delta):
	cursor.position = terrain.get_cell_position_at_mouse_position()

func _draw():
	# DRAW CONNECTIONS
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
				print(n_cell.x)
				n_pos += Vector3(0, 36, 0)
			draw_line(Vector2(p_pos.x, p_pos.y), Vector2(n_pos.x, n_pos.y), Color(255, 0, 0), 1)

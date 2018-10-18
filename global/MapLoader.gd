extends Node

var Terrain = preload("res://terrain/Terrain.tscn")

func load_map(path):
	var terrain = Terrain.instance()
	terrain.name = "Terrain"
	
	terrain.overlay.cell_size = Vector2(54, 72)
	terrain.overlay.cell_half_offset = TileMap.HALF_OFFSET_Y
	terrain.overlay.tile_set = terrain.tile_set
	terrain.add_child(terrain.overlay)
	
	terrain.cover.cell_size = Vector2(54, 72)
	terrain.cover.cell_half_offset = TileMap.HALF_OFFSET_Y
	terrain.cover.tile_set = terrain.tile_set
	terrain.add_child(terrain.cover)
	
	var file = File.new()
	file.open(path, file.READ)
	
	var y = 0
	while not file.eof_reached():
		var line = file.get_csv_line()
		for x in range(line.size()):
			var item = line[x].strip_edges().split("^")
			var base = item[0]
			var id = terrain.tile_set.find_tile_by_name(base)
			terrain.set_cell(x, y, id)
			if (item.size() == 2):
				var overlay_id = terrain.tile_set.find_tile_by_name("^" + item[1])
				terrain.overlay.set_cell(x, y, overlay_id)
		y += 1
	file.close()
	return terrain
	
func save_map(terrain, path):
	var file = File.new()
	if file.open(path, File.WRITE) != OK:
		print("could not save file")
	file.store_line(terrain.get_map_string())
	file.close()
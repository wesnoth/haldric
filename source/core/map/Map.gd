class_name Map extends TileMap

const OFFSET = Vector2(36, 36)
const CELL_SIZE = Vector2(54, 72)

var width := 0
var height := 0

var locations := {}

var overlay := TileMap.new()
var cover := TileMap.new()

var grid : Grid = null

func _init() -> void:
	_setup()

func _ready() -> void:
	width = get_used_rect().size.x
	height = get_used_rect().size.y
	_initialize_locations()
	_initialize_grid()

func map_to_world_centered(cell : Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world_centered(world_to_map(cell))

func get_location(cell : Vector2) -> Location:
	return locations[_flatten(cell)]

func get_map_string() -> String:
	var string = ""
	
	for y in range(height):
		for x in range(width):
			var id = _flatten(Vector2(x, y))
			if get_cell(x, y) == TileMap.INVALID_CELL:
				set_cell(x, y, tile_set.find_tile_by_name("Xv"))
				overlay.set_cell(x, y, TileMap.INVALID_CELL)
			
			var code = tile_set.tile_get_name(get_cell(x, y))
			var overlay_code = ""

			var overlay_cell = overlay.get_cell(x, y)

			if overlay_cell != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay_cell)
			if x < width - 1 and y < height - 1:
				string += code + overlay_code + ","
			else:
				string += code + overlay_code
		string += "\n"
	return string

func _setup() -> void:
	_setup_tilemap(self)
	_setup_tilemap(overlay)
	add_child(overlay)
	_setup_tilemap(cover)
	add_child(cover)

func _setup_tilemap(tilemap : TileMap) -> void:
	tilemap.cell_size = CELL_SIZE
	tilemap.cell_half_offset = TileMap.HALF_OFFSET_Y
	if tilemap == self:
		tilemap.tile_set = Global.tileset
	else:
		tilemap.tile_set = tile_set

func _initialize_locations() -> void:
	for y in range(height):
		for x in range (width):
			var cell := Vector2(x, y)
			var id := _flatten(cell)
			
			var base_code := ""
			var overlay_code := ""
			
			var location := Location.new()
			
			if get_cellv(cell) == TileMap.INVALID_CELL:
				set_cellv(cell, tile_set.find_tile_by_name("Xv"))
				overlay.set_cellv(cell, TileMap.INVALID_CELL)
			
			if overlay.get_cellv(cell) != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay.get_cellv(cell))
			
			base_code = tile_set.tile_get_name(get_cell(x, y))
			
			if overlay_code == "":
				location.terrain = Terrain.new([Registry.terrain[base_code]])
			else:
				location.terrain = Terrain.new([Registry.terrain[base_code], Registry.terrain[overlay_code]])
			
			location.id = id
			location.cell = Vector2(x, y)
			location.position = map_to_world_centered(cell)
			locations[id] = location

func _initialize_grid() -> void:
	grid = Grid.new(self, width, height)

func _flatten(cell : Vector2) -> int:
	return int(cell.y) * int(width) + int(cell.x)
extends TileMap
class_name Map 

const OFFSET = Vector2(36, 36)
const CELL_SIZE = Vector2(54, 72)

var width := 0
var height := 0

var locations := {}

var grid: Grid = null

onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap

func _ready() -> void:
	_update_size()
	_initialize_locations()
	_initialize_grid()
	_initialize_border()

func map_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world_centered(world_to_map(cell))

func find_path(start_loc: Location, end_loc: Location) -> Array:
	var loc_path := []
	var cell_path: Array = grid.find_path_by_cell(start_loc.cell, end_loc.cell)
	
	for cell in cell_path:
		loc_path.append(get_location(cell))
	
	return loc_path
	
func get_location(cell: Vector2) -> Location:
	return locations[_flatten(cell)]

func set_size(cell: Vector2) -> void:
	width = int(cell.x)
	height = int(cell.y)
	
	_initialize_locations()
	_initialize_grid()
	_initialize_border()

func set_tile(global_pos: Vector2, id: int):
	var cell: Vector2 = world_to_map(global_pos)
	
	if _is_out_of_bounds(cell):
		return
	
	if id == -1:
		set_cellv(cell, id)
		overlay.set_cellv(cell, id)
		return
	
	var code: String = tile_set.tile_get_name(id)
	if code.begins_with("^"):
		overlay.set_cellv(cell, id)
		if get_cellv(cell) == -1:
			var grass_id: int = tile_set.find_tile_by_name("Gg")
			set_cellv(cell, grass_id)
	else:
		set_cellv(cell, id)
	_update_size()

func get_map_string() -> String:
	var string := ""
	
	for y in height:
		for x in width:
			var id: int = _flatten(Vector2(x, y))
			if get_cell(x, y) == TileMap.INVALID_CELL:
				set_cell(x, y, tile_set.find_tile_by_name("Xv"))
				overlay.set_cell(x, y, TileMap.INVALID_CELL)
			
			var code: String = tile_set.tile_get_name(get_cell(x, y))
			var overlay_code := ""
			
			var overlay_cell: int = overlay.get_cell(x, y)
			
			if overlay_cell != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay_cell)
			if x < width - 1 and y < height - 1:
				string += code + overlay_code + ","
			else:
				string += code + overlay_code
		string += "\n"
	
	return string

func _initialize_locations() -> void:
	for y in height:
		for x in range (width):
			var cell := Vector2(x, y)
			var id: int = _flatten(cell)
			
			var base_code := ""
			var overlay_code := ""
			
			var location := Location.new()
			
			location.map = self
			
			if get_cellv(cell) == TileMap.INVALID_CELL:
				set_cellv(cell, tile_set.find_tile_by_name("Xv"))
				overlay.set_cellv(cell, TileMap.INVALID_CELL)
			
			if overlay.get_cellv(cell) != TileMap.INVALID_CELL:
				overlay_code = tile_set.tile_get_name(overlay.get_cellv(cell))
			
			base_code = tile_set.tile_get_name(get_cell(x, y))
			
			if overlay_code == "":
				location.terrain = Terrain.new([Registry.terrain[base_code]])
			else:
				location.terrain = Terrain.new([Registry.terrain[base_code],
						Registry.terrain[overlay_code]])
			
			location.id = id
			location.cell = Vector2(x, y)
			location.position = map_to_world_centered(cell)
			locations[id] = location

func _initialize_grid() -> void:
	grid = Grid.new(self, width, height)

func _update_size() -> void:
	if get_cell(0, 0) == -1:
		set_cell(0, 0, tile_set.find_tile_by_name("Xv"))
	width = int(get_used_rect().size.x)
	height = int(get_used_rect().size.y)
	if width % 2 == 0:
		$MapBorder.rect_size =\
				map_to_world(Vector2(width, height)) + Vector2(18, 36)
	else:
		$MapBorder.rect_size =\
				map_to_world(Vector2(width, height)) + Vector2(18, 0)

func _initialize_border() -> void:
	var size := Vector2(width, height)
	print(size)
	$MapBorder.rect_size = map_to_world(size) + Vector2(18, 36)

func _flatten(cell: Vector2) -> int:
	return int(cell.y)*int(width) + int(cell.x)

func _is_out_of_bounds(cell: Vector2) -> bool:
	return cell.x < 0 or cell.x > width or cell.y < 0 or cell.y > height

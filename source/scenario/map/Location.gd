class_name Location
"""
This is an object which contains information about a given hex on the map.
It contains information such as its coordinates on a hex grid, its terrain and any current units in it
"""

const OFFSET = Vector2(36, 36)



var id := 0

var position := Vector2() # Centered position of cell on the tilemap in Axial coordinates
var cell := Vector2() # Position of cell on the tilemap in Axial coordinates
var cube_coords := Vector3() setget _set_cube_coords, _get_cube_coords # Position of cell on the tilemap in Cube coordinates

var flag : Sprite = null

# "map" and "unit" can't be typed because of cyclic recursion.
var map = null
var unit = null

var terrain: Terrain = null

var is_blocked := false

func _init(tilemap_cell_coords: Vector2, map_instance) -> void:
	"""
	Will initialize a location based on the provided position.
	Position can be either Tilemap cell position, or a hex (i.e. cube) coordinate
	It can even be another location instance.
	This function also needs the size of the map
	"""
	map = map_instance
	cell = tilemap_cell_coords
	cube_coords = Hex.quad2cube(cell)
	var rect = map.get_used_rect()
	id = _generate_id(cell, int(rect.size.x))
	position = map.map_to_world_centered(cell)


#func get_position_centered() -> Vector2:
	#return position + OFFSET


func _get_cube_coords() -> Vector3:
	# Returns a Vector3 of the cube coordinates
	return cube_coords

func _set_cube_coords(val: Vector3) -> void:
	# Sets the position from a Vector3 of cube coordinates
	if val.x + val.y + val.z != 0:
		print("WARNING: Invalid cube coordinates for hex (x+y+z!=0): ", val)
		return
	cube_coords = val

static func _generate_id(vec: Vector2, magnitude: int) -> int:
	"""
	Generate a unique ID per tilemap cell
	This is  used for AStar pathfinding
	The unique ID for each cell in the tilemap is:
		y.position of the cell * the total width of the tilemap + x.position of the cell
	E.g. cell in position (3,5) of a 10x10 map, will have ID = 53
	"""
	return int(vec.y) * magnitude + int(vec.x)

func get_adjacent_locations() -> Array:
	var neighbor_locations := []
	for hex in Hex.get_neighbors(cell):
		var neighbor = map.locations_dict.get(hex, null)
		if neighbor:
			neighbor_locations.append(neighbor)
	return neighbor_locations

func can_recruit_from():
	return terrain.recruit_from && get_adjacent_free_recruitment_location() != null

func get_adjacent_free_recruitment_location() -> Location:
	for target_location in get_adjacent_locations():
		if target_location._can_recruit_to():
			return target_location
	return null

func _can_recruit_to():
	return terrain.recruit_onto && unit == null

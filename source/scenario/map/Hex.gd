class_name Hex

enum DIRECTIONS { N, NE, SE, S, SW, NW }

const NEIGHBOUR_TABLE = [
	# EVEN col, ALL rows
	[
		Vector2(0, -1), # N
		Vector2(1, -1), # NE
		Vector2(1, 0), # SE
		Vector2(0, 1), # S
		Vector2(-1, 0), # SW
		Vector2(-1, -1) # NW
	],
	# ODD col, ALL rows
	[
		Vector2(0, -1), # N
		Vector2(1, 0), # NE
		Vector2(1, 1), # SE
		Vector2(0, 1), # S
		Vector2(-1, 1), # SW
		Vector2(-1,  0) # NW
	]
]

# Directions of neighbouring cells in Vect3 cube format
const DIR_N = Vector3(0, 1, -1)
const DIR_NE = Vector3(1, 0, -1)
const DIR_SE = Vector3(1, -1, 0)
const DIR_S = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_NW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW, DIR_NW]

# Cube coords are canonical
var cube_coords = Vector3(0, 0, 0) setget set_cube_coords, get_cube_coords
# but other coord systems can be used
var axial_coords setget set_axial_coords, get_axial_coords
var offset_coords setget set_offset_coords, get_offset_coords

func _init(coords=null):
	# HexCells can be created with coordinates
	if coords:
		self.cube_coords = obj_to_coords(coords)

func new_hex(coords):
	# Returns a new HexCell instance
	return get_script().new(coords)
	
func get_cube_coords():
	# Returns a Vector3 of the cube coordinates
	return cube_coords
	
func set_cube_coords(val):
	# Sets the position from a Vector3 of cube coordinates
	if abs(val.x + val.y + val.z) > 0.0001:
		print("WARNING: Invalid cube coordinates for hex (x+y+z!=0): ", val)
		return
	cube_coords = round_coords(val)
	
func get_axial_coords():
	# Returns a Vector2 of the axial coordinates
	return Vector2(cube_coords.x, cube_coords.y)
	
func set_axial_coords(val):
	# Sets position from a Vector2 of axial coordinates
	set_cube_coords(axial_to_cube_coords(val))
	
func get_offset_coords():
	# Returns a Vector2 of the offset (i.e. Tilemap) coordinates
	var x = int(cube_coords.x)
	var z = int(cube_coords.z)
	var off_z = z + (x - (x & 1)) / 2
	return Vector2(x, off_z)
	
func set_offset_coords(val):
	# Sets position from a Vector2 of offset (i.e. Tilemap)  coordinates
	var x = int(val.x)
	var y = int(val.y)
	var cube_y = y - (x - (x & 1)) / 2
	self.set_axial_coords(Vector2(x, cube_y))

"""
	Handle coordinate access and conversion
"""
func obj_to_coords(val):
	# Returns suitable cube coordinates for the given object
	# The given object can an be one of:
	# * Vector3 of standard cube coords;
	# * Vector2 of axial coords;
	# * HexCell instance
	# Any other type of value will return null
	#
	# NB that offset coords are NOT supported, as they are
	# indistinguishable from axial coords.
	
	if typeof(val) == TYPE_VECTOR3:
		return val
	elif typeof(val) == TYPE_VECTOR2:
		return axial_to_cube_coords(val)
	elif typeof(val) == TYPE_OBJECT and val.has_method("get_cube_coords"):
		return val.get_cube_coords()
	# Fall through to nothing
	return
	
func axial_to_cube_coords(val):
	# Returns the Vector3 cube coordinates for an axial Vector2
	var x = val.x
	var y = val.y
	return Vector3(x, y, -x - y)
	
func round_coords(val):
	# Rounds floaty coordinate to the nearest whole number cube coords
	if typeof(val) == TYPE_VECTOR2:
		val = axial_to_cube_coords(val)
	
	# Straight round them
	var rounded = Vector3(round(val.x), round(val.y), round(val.z))
	
	# But recalculate the one with the largest diff so that x+y+z=0
	var diffs = (rounded - val).abs()
	if diffs.x > diffs.y and diffs.x > diffs.z:
		rounded.x = -rounded.y - rounded.z
	elif diffs.y > diffs.z:
		rounded.y = -rounded.x - rounded.z
	else:
		rounded.z = -rounded.x - rounded.y
	
	return rounded


"""
	Finding our neighbours
"""
func get_adjacent(dir):
	# Returns a HexCell instance for the given direction from this.
	# Intended for one of the DIR_* consts, but really any Vector2 or x+y+z==0 Vector3 will do.
	if typeof(dir) == TYPE_VECTOR2:
		dir = axial_to_cube_coords(dir)
	return new_hex(self.cube_coords + dir)
	
func get_all_adjacent():
	# Returns an array of HexCell instances representing adjacent locations
	var cells = Array()
	for coord in DIR_ALL:
		cells.append(new_hex(self.cube_coords + coord))
	return cells
	
func get_all_within(distance):
	# Returns an array of all HexCell instances within the given distance
	var cells = Array()
	for dx in range(-distance, distance+1):
		for dy in range(max(-distance, -distance - dx), min(distance, distance - dx) + 1):
			cells.append(new_hex(self.axial_coords + Vector2(dx, dy)))
	return cells
	
func get_ring(distance):
	# Returns an array of all HexCell instances at the given distance
	if distance < 1:
		return [new_hex(self.cube_coords)]
	# Start at the top (+y) and walk in a clockwise circle
	var cells = Array()
	var current = new_hex(self.cube_coords + (DIR_N * distance))
	for dir in [DIR_SE, DIR_S, DIR_SW, DIR_NW, DIR_N, DIR_NE]:
		for _step in range(distance):
			cells.append(current)
			current = current.get_adjacent(dir)
	return cells









static func get_cells_around(cell: Vector2, _range: int, size: Vector2) -> PoolVector2Array:
	var cells := PoolVector2Array()
	for n in range(1, _range + 1):
		var current_cell := Vector2(cell.x, cell.y + n)
		for j in 6:
			for i in n:
				var parity := int(current_cell.x) & 1
				var temp: Vector2 = NEIGHBOUR_TABLE[parity][(j + 5) % 6]
				current_cell += temp
				if current_cell.x >= 0 and current_cell.x < size.x and current_cell.y >= 0 and current_cell.y < size.y:
					cells.append(current_cell)
	return cells

static func get_neighbors(cell: Vector2) -> Array:
	var neighbors := []
	for direction in DIRECTIONS:
		neighbors.append(get_neighbor(cell, DIRECTIONS[direction]))

	return neighbors

static func get_neighbor(cell: Vector2, direction: int) -> Vector2:
	var parity := int(cell.x) & 1
	var neighbor : Vector2 = NEIGHBOUR_TABLE[parity][direction]

	return Vector2(cell.x + neighbor.x, cell.y + neighbor.y)

static func hex_to_quad(hex: Vector3) -> Vector2:
	var col := hex.x
	var row := hex.z + (hex.x - (int(hex.x) & 1)) / 2

	return Vector2(col, row)

static func quad_to_hex(hex: Vector2) -> Vector3:
	var x := hex.x
	var z := hex.y - (hex.x - (int(hex.x) & 1)) / 2
	var y := -x - z

	return Vector3(x, y, z)

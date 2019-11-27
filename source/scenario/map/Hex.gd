class_name Hex

enum DIRECTIONS { N, NE, SE, S, SW, NW }

const NEIGHBOUR_TABLE_OLD = [
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

"""


enum DIRECTIONS { S, SW, NW, N, NE, SE }
"""

const NEIGHBOR_TABLE := [
	Vector3(0, 1, -1), # N
	Vector3(1, 0, -1), # NE
	Vector3(1, -1, 0), # SE
	Vector3(0, -1, 1), # S
	Vector3(-1, 0, 1), # SW
	Vector3(-1, 1, 0), # NW
]

static func get_cells_around(cell: Vector2, _range: int, size: Vector2) -> PoolVector2Array:
	var cells := PoolVector2Array()
	for n in range(1, _range + 1):
		var current_cell := Vector2(cell.x, cell.y + n)
		for j in 6:
			for i in n:
				var parity := int(current_cell.x) & 1
				var temp: Vector2 = NEIGHBOUR_TABLE_OLD[parity][(j + 5) % 6]
				current_cell += temp
				if current_cell.x >= 0 and current_cell.x < size.x and current_cell.y >= 0 and current_cell.y < size.y:
					cells.append(current_cell)
	return cells


static func get_neighbors(cell: Vector2) -> Array:
	var neighbors := []
	var cube_neighbors := get_cube_neighbors(quad2cube(cell))
	for n_cube in cube_neighbors:
		neighbors.append(cube2quad(n_cube))
	return neighbors

static func get_neighbor(cell: Vector2, direction: int) -> Vector2:
	return cube2quad(get_cube_neighbor(quad2cube(cell), direction))

static func get_cube_neighbors(cube: Vector3) -> Array:
	var neighbors := []
	for direction in DIRECTIONS:
		neighbors.append(get_cube_neighbor(cube, DIRECTIONS[direction]))
	return neighbors

static func get_cube_neighbor(cube: Vector3, direction: int) -> Vector3:
	return cube + NEIGHBOR_TABLE[direction]

static func cube_distance(a: Vector3, b: Vector3):
	return max(abs(a.x - b.x), max(abs(a.y - b.y), abs(a.z - b.z)))

static func cube2quad(cube: Vector3) -> Vector2:
	var x := cube.x
	var y := cube.z + (cube.x - (int(cube.x) & 1)) / 2

	return Vector2(x, y)

static func quad2cube(quad: Vector2) -> Vector3:
	var x := quad.x
	var z := quad.y - (quad.x - (int(quad.x) & 1)) / 2
	var y := -x - z

	return Vector3(x, y, z)

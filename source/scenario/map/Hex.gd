class_name Hex

enum DIRECTIONS { N, NE, SE, S, SW, NW }
# enum DIRECTIONS { S, SW, NW, N, NE, SE }

const NEIGHBOR_TABLE := [
	Vector3(0, 1, -1), # N
	Vector3(1, 0, -1), # NE
	Vector3(1, -1, 0), # SE
	Vector3(0, -1, 1), # S
	Vector3(-1, 0, 1), # SW
	Vector3(-1, 1, 0), # NW
]

static func get_cells_in_range(cell: Vector2, radius: int, rect: Rect2) -> PoolVector2Array:
	var cells : PoolVector2Array = []
	var cubes = get_cubes_in_range(quad2cube(cell), radius)
	for cube in cubes:
		var n_cell = cube2quad(cube)
		if rect.has_point(n_cell):
			cells.append(n_cell)
	return cells

static func get_cubes_in_range(cube: Vector3, radius: int) -> PoolVector3Array:
	var cubes : PoolVector3Array = []
	for x in range(-radius, radius + 1):
		for y in range(max(-radius, -x - radius), min(radius, -x + radius)):
			var z = -x - y
			cubes.append(cube + Vector3(x, y, z))
	return cubes

static func get_cube_spiral(cube: Vector3, radius) -> PoolVector3Array:
	var spiral : PoolVector3Array = [ cube ]
	for i in range(1, radius + 1):
		spiral += get_cube_ring(cube, i)
	return spiral

static func get_cube_ring(cube: Vector3, radius: int) -> PoolVector3Array:
	var ring : PoolVector3Array = []
	var start_cube = get_cube_neighbor(cube, 0, radius)

	print("Cube: ", cube, ", Radius: ", radius, ", Start Cube: ", start_cube - cube)

	for direction in DIRECTIONS:
		for i in radius:
			ring.append(start_cube)
			start_cube = get_cube_neighbor(start_cube, DIRECTIONS[direction])

	return ring

static func get_neighbors(cell: Vector2) -> PoolVector2Array:
	var neighbors : PoolVector2Array = []
	var cube_neighbors := get_cube_neighbors(quad2cube(cell))
	for n_cube in cube_neighbors:
		neighbors.append(cube2quad(n_cube))
	return neighbors

static func get_neighbor(cell: Vector2, direction: int) -> Vector2:
	return cube2quad(get_cube_neighbor(quad2cube(cell), direction))

static func get_cube_neighbors(cube: Vector3) -> PoolVector3Array:
	var neighbors : PoolVector3Array = []
	for direction in DIRECTIONS:
		neighbors.append(get_cube_neighbor(cube, DIRECTIONS[direction]))
	return neighbors

static func get_cube_neighbor(cube: Vector3, direction: int, scale := 1) -> Vector3:
	return cube + (NEIGHBOR_TABLE[direction] * scale)

static func get_cube_distance(a: Vector3, b: Vector3):
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

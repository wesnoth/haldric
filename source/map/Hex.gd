class_name Hex

enum Direction { N, NE, SE, S, SW, NW }

const CELL_SIZE := Vector2(54, 72)
const OFFSET := Vector2(36, 36)

const NEIGHBOR_TABLE := [
	Vector3(0, 1, -1), # N
	Vector3(1, 0, -1), # NE
	Vector3(1, -1, 0), # SE
	Vector3(0, -1, 1), # S
	Vector3(-1, 0, 1), # SW
	Vector3(-1, 1, 0), # NW
]


static func map_to_world(cell: Vector2) -> Vector2:
	var x : int = cell.x * CELL_SIZE.x
	var y : int = cell.y * CELL_SIZE.y

	if int(cell.x) & 1:
		y -= OFFSET.y

	return Vector2(x, y)


static func map_to_world_centered(cell: Vector2) -> Vector2:
	return map_to_world(cell) + OFFSET


static func world_to_map(position: Vector2) -> Vector2:
	var x : int = position.x / CELL_SIZE.x

	var temp_position = position

	if not x & 1:
		temp_position.y += OFFSET.y

	var diff_x : int = int(temp_position.x) % int(CELL_SIZE.x)
	var diff_y : int = int(temp_position.y) % int(CELL_SIZE.y)

	var diff_y_centered : int = OFFSET.y - abs(diff_y - OFFSET.y)

	if diff_x <= diff_y_centered / 2:
		position.x -= OFFSET.x

	x = position.x / CELL_SIZE.x

	if x & 1:
		position.y += OFFSET.y

	var y : int = position.y / CELL_SIZE.y

	return Vector2(x, y)


static func get_neighbor(cell: Vector2, direction: int) -> Vector2:
	return cube2quad(_get_cube_neighbor(quad2cube(cell), direction))


static func get_neighbors(cell: Vector2) -> PoolVector2Array:
	var neighbors : PoolVector2Array = []
	var cube_neighbors := _get_cube_neighbors(quad2cube(cell))

	for n_cube in cube_neighbors:
		neighbors.append(cube2quad(n_cube))

	return neighbors


static func get_cell_distance(a: Vector2, b: Vector2) -> int:
	return _get_cube_distance(quad2cube(a), quad2cube(b))


static func get_cells_in_range(cell: Vector2, radius: int, rect: Rect2) -> PoolVector2Array:

	var cells := PoolVector2Array()

	cells.append(cell)

	if radius == 0:
		return cells

	var cubes = _get_cubes_in_range(quad2cube(cell), radius)

	for cube in cubes:
		var n_quad = cube2quad(cube)

		if rect.has_point(n_quad):
			cells.append(n_quad)

	return cells


static func get_cell_ring(cell: Vector2, radius: int, rect: Rect2) -> PoolVector2Array:
	var cells := PoolVector2Array()
	var cubes := _get_cube_ring(quad2cube(cell), radius)

	for cube in cubes:
		if rect.has_point(cube2quad(cube)):
			cells.append(cube2quad(cube))

	return cells

static func is_cell_neighbor(origin: Vector2, cell: Vector2) -> bool:
	return _get_cube_neighbors(quad2cube(origin)).has(quad2cube(cell))


static func is_cell_in_range(origin: Vector2, cell: Vector2, radius: int) -> bool:
	return _get_cubes_in_range(quad2cube(origin), radius).has(quad2cube(cell))


static func cube2quad(cube: Vector3) -> Vector2:
	var x := cube.x
	var y := cube.z + (cube.x + (int(cube.x) & 1)) / 2

	return Vector2(x, y)


static func quad2cube(quad: Vector2) -> Vector3:
	var x := quad.x
	var z := quad.y - (quad.x + (int(quad.x) & 1)) / 2
	var y := -x - z

	return Vector3(x, y, z)


static func _get_cubes_in_range(cube: Vector3, radius: int) -> Array:
	var cubes : Array = []

	for x in range(-radius, radius + 1):
		for y in range(max(-radius, -x - radius), min(radius + 1, -x + radius + 1)):
			var z = -x - y
			cubes.append(cube + Vector3(x, y, z))

	return cubes


static func _get_cube_spiral(cube: Vector3, radius) -> Array:
	var spiral : Array = [ cube ]

	for i in range(1, radius + 1):
		spiral += _get_cube_ring(cube, i)

	return spiral


static func _get_cube_ring(cube: Vector3, radius: int) -> Array:
	var ring : Array = []
	var start_cube = _get_cube_neighbor(cube, 4, radius)

	for direction in Direction:
		for __ in radius:
			ring.append(start_cube)
			start_cube = _get_cube_neighbor(start_cube, Direction[direction])

	return ring


static func _get_cube_neighbors(cube: Vector3) -> Array:
	var neighbors : Array = []

	for direction in Direction:
		neighbors.append(_get_cube_neighbor(cube, Direction[direction]))

	return neighbors


static func _get_cube_neighbor(cube: Vector3, direction: int, scale := 1) -> Vector3:
	return cube + (NEIGHBOR_TABLE[direction] * scale)


static func _get_cube_distance(a: Vector3, b: Vector3):
	return max(abs(a.x - b.x), max(abs(a.y - b.y), abs(a.z - b.z)))

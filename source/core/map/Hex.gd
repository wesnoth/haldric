class_name Hex

enum DIRECTIONS { N = 0, NE = 1, SE = 2, S = 3, SW = 4, NW = 5}

const NEIGHBOUR_TABLE = [
	# EVEN col, ALL rows
    [
		Vector2(0, -1), # N
		Vector2(+1, -1), # NE
		Vector2(+1,  0), # SE
		Vector2(0, +1), # S
		Vector2(-1,  0), # SW
		Vector2(-1, -1) # NW
	],
	# ODD col, ALL rows
    [
		Vector2(0, -1), # N
		Vector2(+1,  0), # NE
		Vector2(+1, +1), # SE
		Vector2( 0, +1), # S
		Vector2(-1, +1), # SW
		Vector2(-1,  0) # NW
	]]

static func get_neighbors(cell : Vector2) -> Array:
	var neighbors := []
	for direction in DIRECTIONS:
		neighbors.append(get_neighbor(cell, DIRECTIONS[direction]))
	return neighbors

static func get_neighbor(cell : Vector2, direction : int) -> Vector2:
	var parity := int(cell.x) & 1
	var neighbor : Vector2 = NEIGHBOUR_TABLE[parity][direction]
	return Vector2(cell.x + neighbor.x, cell.y + neighbor.y)

static func hex_to_quad(hex : Vector3) -> Vector2:
    var col := hex.x
    var row := hex.z + (hex.x - (int(hex.x) & 1)) / 2
    return Vector2(col, row)

static func quad_to_hex(hex : Vector2) -> Vector3:
    var x := hex.x
    var z := hex.y - (hex.x - (int(hex.x) & 1)) / 2
    var y := -x-z
    return Vector3(x, y, z)
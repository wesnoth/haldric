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

static func get_cells_in_range(cell: Vector2, _range: int, width: int, height: int) -> Array:
	var cells := [ cell ]
	for n in range(1,_range+1):
		var current_cell := Vector2(cell.x, cell.y + n)
		for j in 6:
			for i in n:
				var parity : int = int(current_cell.x) & 1
				var temp : Vector2 = NEIGHBOUR_TABLE[parity][(j+5)%6]
				current_cell += temp
				if current_cell.x >= 0 and current_cell.x < width and current_cell.y >= 0 and current_cell.y < height:
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

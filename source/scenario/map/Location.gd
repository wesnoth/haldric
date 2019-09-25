class_name Location
"""
This is an object which contains information about a given hex on the map. 
It contains information such as its coordinates on a hex grid, its terrain and any current units in it
"""

const OFFSET = Vector2(36, 36)

var id := 0

var position := Vector2() # Centered position of cell on the tilemap in Axial coordinates
var cell := Vector2() # Position of cell on the tilemap in Axial coordinates
var hex := Vector3() # Position of cell on the tilemap in Cube coordinates

var flag : Sprite = null

# "map" and "unit" can't be typed because of cyclic recursion.
var map = null
var unit = null

var terrain: Terrain = null

var is_blocked := false

func get_position_centered() -> Vector2:
	return position + OFFSET

extends Resource
class_name Location

var id := 0

var cell := Vector2()
var position := Vector2()

var unit : Unit = null setget _set_unit
var terrain : Terrain = null

var _neighbors := []

var castle := []
var side_number := -1


func _init() -> void:
	_neighbors.resize(6)


func add_neighbor(loc: Location, direction: int) -> void:
	_neighbors[direction] = loc


func get_neighbor(direction: int) -> Location:
	return _neighbors[direction]


func get_neighbors() -> Array:
	return _neighbors


func duplicate(subresources := false) -> Resource:
	var res = .duplicate(subresources)
	res.id = id
	res.cell = cell
	res.position = position
	res.terrain = terrain
	res.unit = unit
	res.terrain = terrain
	res.castle = castle
	res.side_number = side_number
	return res


func _set_unit(_unit: Unit) -> void:
	if unit:
		unit.disconnect("died", self, "_on_unit_died")

	unit = _unit

	if unit:
		unit.connect("died", self, "_on_unit_died")


func _on_unit_died(_unit: Unit) -> void:
	unit = null

extends "res://addons/gut/test.gd"


class TestConversions:
	extends "res://addons/gut/test.gd"

	func setup():
		pass


	func test_offset_to_cube():
		assert_eq(Hex.cube2quad(Vector3(2, -3, 1)), Vector2(2, 2), "Check positive cube to offset conversion")
		assert_eq(Hex.cube2quad(Vector3(-3, -5, 2)), Vector2(-3, 0), "Check negative cube to offset conversion")
		assert_eq(Hex.quad2cube(Vector2(2, 2)), Vector3(2, -3, 1), "Check positive offset to cube conversion")
		assert_eq(Hex.quad2cube(Vector2(-3, -3)), Vector3(-3, 4, -1), "Check positive offset to cube conversion")


class TestNearby:
	extends "res://addons/gut/test.gd"

	func setup():
		pass

	func test_neighbors():
		assert_eq(Hex.get_neighbor(Vector2(1, 1), 0), Vector2(1,0), "Check north direction")
		assert_eq(Hex.get_neighbor(Vector2(4, -5), 4), Vector2(3,-5), "Check southwest direction")

	func test_neighborhood():
		assert_eq(Hex.get_neighbors(Vector2(1, -1)), [Vector2(1, -2), Vector2(2, -1), Vector2(2, 0), Vector2(1, 0), Vector2(0, 0), Vector2(0, -1)], "Check surrounding ceels")

	func test_radius():
		var offset_coords = Vector2(0, -2)
		var radius = 5
		var rect = Rect2(0, 0, 10,10)
		var cells_list = Hex.get_cells_around(offset_coords, radius, rect)
		assert_eq(cells_list.size(), 15, "Check correct amount of hexes collected in radius")
		rect.size = Vector2(4,4)
		cells_list = Hex.get_cells_around(offset_coords, radius, rect)
		assert_eq(cells_list.size(), 12, "Check correct amount of hexes collected in a smaller grid")

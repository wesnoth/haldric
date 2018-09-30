"""
	A converter between hex and Godot-space coordinate systems.
	
	The hex grid uses +x => NE and +y => N, whereas
	the projection to Godot-space uses +x => E, +y => S.
	
	We map hex coordinates to Godot-space with +y flipped to be the down vector
	so that it maps neatly to both Godot's 2D coordinate system, and also to
	x,z planes in 3D space.
	
	
	## Usage:
	
	#### var hex_scale = Vector2(...)

		If you want your hexes to display larger than the default 1 x 0.866 units,
		then you can customise the scale of the hexes using this property.
	
	#### func get_hex_center(hex)
	
		Returns the Godot-space Vector2 of the center of the given hex.
		
		The coordinates can be given as either a HexCell instance; a Vector3 cube
		coordinate, or a Vector2 axial coordinate.
	
	#### func get_hex_center3(hex [, y])
	
		Returns the Godot-space Vector3 of the center of the given hex.
		
		The coordinates can be given as either a HexCell instance; a Vector3 cube
		coordinate, or a Vector2 axial coordinate.
		
		If a second parameter is given, it will be used for the y value in the
		returned Vector3. Otherwise, the y value will be 0.
	
	#### func get_hex_at(coords)
	
		Returns HexCell whose grid position contains the given Godot-space coordinates.
		
		The given value can either be a Vector2 on the grid's plane
		or a Vector3, in which case its (x, z) coordinates will be used.
	
	
	### Path-finding
	
	HexGrid also includes an implementation of the A* pathfinding algorithm.
	The class can be used to populate an internal representation of a game grid
	with obstacles to traverse.
	
	#### func set_bounds(min_coords, max_coords)
	
		Sets the hard outer limits of the path-finding grid.
		
		The coordinates given are the min and max corners *inside* a bounding
		square (diamond in hex visualisation) region. Any hex outside that area
		is considered an impassable obstacle.
		
		The default bounds consider only the origin to be inside, so you're probably
		going to want to do something about that.
	
	#### func get_obstacles()
	
		Returns a dict of all obstacles and their costs
		
		The keys are Vector2s of the axial coordinates, the values will be the
		cost value. Zero cost means an impassable obstacle.
	
	#### func add_obstacles(coords, cost=0)
	
		Adds one or more obstacles to the path-finding grid
		
		The given coordinates (axial or cube), HexCell instance, or array thereof,
		will be added as path-finding obstacles with the given cost. A zero cost
		indicates an impassable obstacle.
	
	#### func remove_obstacles(coords)
	
		Removes one or more obstacles from the path-finding grid
		
		The given coordinates (axial or cube), HexCell instance, or array thereof,
		will be removed as obstacles from the path-finding grid.
	
	#### func get_barriers()
	
		Returns a dict of all barriers in the grid.
		
		A barrier is an edge of a hex which is either impassable, or has a
		non-zero cost to traverse. If two adjacent hexes both have barriers on
		their shared edge, their costs are summed.
		Barrier costs are in addition to the obstacle (or default) cost of
		moving to a hex.
		
		The outer dict is a mapping of axial coords to an inner barrier dict.
		The inner dict maps between HexCell.DIR_* directions and the cost of
		travel in that direction. A cost of zero indicates an impassable barrier.
	
	#### func add_barriers(coords, dirs, cost=0)
	
		Adds one or more barriers to locations on the grid.
		
		The given coordinates (axial or cube), HexCell instance, or array thereof,
		will have path-finding barriers added in the given HexCell.DIR_* directions
		with the given cost. A zero cost indicates an impassable obstacle.
		
		Existing barriers at given coordinates will not be removed, but will be
		overridden if the direction is specified.
	
	#### func remove_barriers(coords, dirs=null)
	
		Remove one or more barriers from the path-finding grid.
		
		The given coordinates (axial or cube), HexCell instance, or array thereof,
		will have the path-finding barriers in the supplied HexCell.DIR_* directions
		removed. If no direction is specified, all barriers for the given
		coordinates will be removed.
	
	#### func get_hex_cost(coords)
	
		Returns the cost of moving into the specified grid position.
		
		Will return 0 if the given grid position is inaccessible.
	
	#### func get_move_cost(coords, direction)
	
		Returns the cost of moving from one hex to an adjacent one.
		
		This method takes into account any barriers defined between the two
		hexes, as well as the cost of the target hex.
		Will return 0 if the target hex is inaccessible, or if there is an
		impassable barrier between the hexes.
		
		The direction should be provided as one of the HexCell.DIR_* values.
	
	#### func get_path(start, goal, exceptions=[])
	
		Calculates an A* path from the start to the goal.
		
		Returns a list of HexCell instances charting the path from the given start
		coordinates to the goal, including both ends of the journey.
		
		Exceptions can be specified as the third parameter, and will act as
		impassable obstacles for the purposes of this call of the function.
		This can be used for pathing around obstacles which may change position
		(eg. enemy playing pieces), without having to update the grid's list of
		obstacles every time something moves.
		
		If the goal is an impassable location, the path will terminate at the nearest
		adjacent coordinate. In this instance, the goal hex will not be included in
		the returned array.
		
		If there is no path possible to the goal, or any hex adjacent to it, an
		empty array is returned. But the algorithm will only know that once it's
		visited every tile it can reach, so try not to path to the impossible.
	
"""
extends Resource

var HexCell = preload("./HexCell.gd")
# Duplicate these from HexCell for ease of access
const DIR_N = Vector3(0, 1, -1)
const DIR_NE = Vector3(1, 0, -1)
const DIR_SE = Vector3(1, -1, 0)
const DIR_S = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_NW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW, DIR_NW]

# Allow the user to scale the hex for fake perspective or somesuch
export(Vector2) var hex_scale = Vector2(1, 1) setget set_hex_scale

var base_hex_size = Vector2(1, 1)
var hex_size
var hex_transform
var hex_transform_inv
# Pathfinding obstacles {Vector2: cost}
# A zero cost means impassable
var path_obstacles = {}
# Barriers restrict traversing between edges (in either direction)
# costs for barriers and obstacles are cumulative, but impassable is impassable
# {Vector2: {DIR_VECTOR2: cost, ...}}
var path_barriers = {}
var path_bounds = Rect2()
var path_cost_default = 1.0


func _init():
	set_hex_scale(hex_scale)


func set_hex_scale(scale):
	# We need to recalculate some stuff when projection scale changes
	hex_scale = scale
	hex_size = base_hex_size * hex_scale
	hex_transform = Transform2D(
		Vector2(hex_size.x * 3/4, -hex_size.y / 2),
		Vector2(0, -hex_size.y),
		Vector2(0, 0)
	)
	hex_transform_inv = hex_transform.affine_inverse()
	

"""
	Converting between hex-grid and 2D spatial coordinates
"""
func get_hex_center(hex):
	# Returns hex's centre position on the projection plane
	hex = HexCell.new(hex)
	return hex_transform * hex.axial_coords
	
func get_hex_at(coords):
	# Returns a HexCell at the given Vector2/3 on the projection plane
	# If the given value is a Vector3, its x,z coords will be used
	if typeof(coords) == TYPE_VECTOR3:
		coords = Vector2(coords.x, coords.z)
	return HexCell.new(hex_transform_inv * coords)
	
func get_hex_center3(hex, y=0):
	# Returns hex's centre position as a Vector3
	var coords = get_hex_center(hex)
	return Vector3(coords.x, y, coords.y)
	

"""
	Pathfinding
	
	Ref: https://www.redblobgames.com/pathfinding/a-star/introduction.html
	
	We use axial coords for everything internally (to use Rect2.has_point),
	but the methods accept cube or axial coords, or HexCell instances.
"""
func set_bounds(min_coords, max_coords):
	# Set the absolute bounds of the pathfinding area in grid coords
	# The given coords will be inside the boundary (hence the extra (1, 1))
	min_coords = HexCell.new(min_coords).axial_coords
	max_coords = HexCell.new(max_coords).axial_coords
	path_bounds = Rect2(min_coords, (max_coords - min_coords) + Vector2(1, 1))
	
func get_obstacles():
	return path_obstacles
	
func add_obstacles(vals, cost=0):
	# Store the given coordinate/s as obstacles
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).axial_coords
		path_obstacles[coords] = cost
	
func remove_obstacles(vals):
	# Remove the given obstacle/s from the grid
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).axial_coords
		path_obstacles.erase(coords)
	
func get_barriers():
	return path_barriers
	
func add_barriers(vals, dirs, cost=0):
	# Store the given directions of the given locations as barriers
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	if not typeof(dirs) == TYPE_ARRAY:
		dirs = [dirs]
	for coords in vals:
		coords = HexCell.new(coords).axial_coords
		var barriers = {}
		if coords in path_barriers:
			# Already something there
			barriers = path_barriers[coords]
		else:
			path_barriers[coords] = barriers
		# Set or override the given dirs
		for dir in dirs:
			barriers[dir] = cost
		path_barriers[coords] = barriers
	
func remove_barriers(vals, dirs=null):
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	if dirs != null and not typeof(dirs) == TYPE_ARRAY:
		dirs = [dirs]
	for coords in vals:
		coords = HexCell.new(coords).axial_coords
		if dirs == null:
			path_barriers.erase(coords)
		else:
			for dir in dirs:
				path_barriers[coords].erase(dir)
	

func get_hex_cost(coords):
	# Returns the cost of moving to the given hex
	coords = HexCell.new(coords).axial_coords
	if coords in path_obstacles:
		return path_obstacles[coords]
	if not path_bounds.has_point(coords):
		# Out of bounds
		return 0
	return path_cost_default
	
func get_move_cost(coords, direction):
	# Returns the cost of moving from one hex to a neighbour
	direction = HexCell.new(direction).cube_coords
	var start_hex = HexCell.new(coords)
	var target_hex = HexCell.new(start_hex.cube_coords + direction)
	coords = start_hex.axial_coords
	# First check if either end is completely impassable
	var cost = get_hex_cost(start_hex)
	if cost == 0:
		return 0
	cost = get_hex_cost(target_hex)
	if cost == 0:
		return 0
	# Check for barriers
	var barrier_cost
	if coords in path_barriers and direction in path_barriers[coords]:
		barrier_cost = path_barriers[coords][direction]
		if barrier_cost == 0:
			return 0
		cost += barrier_cost
	var target_coords = target_hex.axial_coords
	if target_coords in path_barriers and -direction in path_barriers[target_coords]:
		barrier_cost = path_barriers[target_coords][-direction]
		if barrier_cost == 0:
			return 0
		cost += barrier_cost
	return cost
	

func get_path(start, goal, exceptions=[]):
	# Light a starry path from the start to the goal, inclusive
	start = HexCell.new(start).axial_coords
	goal = HexCell.new(goal).axial_coords
	# Make sure all the exceptions are axial coords
	var exc = []
	for ex in exceptions:
		exc.append(HexCell.new(ex).axial_coords)
	exceptions = exc
	# Now we begin the A* search
	var frontier = [make_priority_item(start, 0)]
	var came_from = {start: null}
	var cost_so_far = {start: 0}
	while not frontier.empty():
		var current = frontier.pop_front().v
		if current == goal:
			break
		for next_hex in HexCell.new(current).get_all_adjacent():
			var next = next_hex.axial_coords
			var next_cost = get_move_cost(current, next - current)
			if next == goal and (next in exceptions or get_hex_cost(next) == 0):
				# Our goal is an obstacle, but we're next to it
				# so our work here is done
				came_from[next] = current
				frontier.clear()
				break
			if not next_cost or next in exceptions:
				# We shall not pass
				continue
			next_cost += cost_so_far[current]
			if not next in cost_so_far or next_cost < cost_so_far[next]:
				# New shortest path to that node
				cost_so_far[next] = next_cost
				var priority = next_cost + next_hex.distance_to(goal)
				# Insert into the frontier
				var item = make_priority_item(next, priority)
				var idx = frontier.bsearch_custom(item, self, "comp_priority_item")
				frontier.insert(idx, item)
				came_from[next] = current
	
	if not goal in came_from:
		# Not found
		return []
	# Follow the path back where we came_from
	var path = []
	if not (goal in path_obstacles or goal in exceptions):
		# We only include the goal if it's traversable
		path.append(HexCell.new(goal))
	var current = goal
	while current != start:
		current = came_from[current]
		path.push_front(HexCell.new(current))
	return path
	
# Used to make a priority queue out of an array
func make_priority_item(val, priority):
	return {"v": val, "p": priority}
func comp_priority_item(a, b):
	return a.p < b.p

extends TileMap
class_name Map
"""
An object for the map itself
Its primary location is to contain and prepare the relationaship of locations to each other
It is also the primary viewport on which the mouse is moving, so some it's responsible for
  translating mouse position to hex position and vice-versa.
"""
const OFFSET := Vector2(36, 36) # Half the size of the tilemap cell size, so that the highlight display is centered on the hex

const DEFAULT_TERRAIN := "Gg"
const VOID_TERRAIN := "Xv"

var default_tile := tile_set.find_tile_by_name(DEFAULT_TERRAIN)
var void_tile := tile_set.find_tile_by_name(VOID_TERRAIN)

var rect := Rect2() # Used to store the x*y size of the map in square tiles

var map_data := {}

var labels := []
var locations_dict := {} # A dictionary which stores all the locations objects of this scenario.
var grid: Grid = null # An object which holds the astar connections
var ZOC_tiles := {} # Hexes exert a Zone of Control (because a unit is on them)
					# Each key is a location instance
					# Each value is the location objects (typically all adjacent hexes) which are under this location's ZoC


onready var overlay := $Overlay as TileMap
onready var cover := $Cover as TileMap
onready var highlight := $Highlight as TileMap
onready var transitions := $Transitions as Transitions

onready var border := $MapBorder # The hexes which are renderred but not playable
onready var hover := $Hover # The highlight hex sprite to see which hex your mouse is over.

func initialize() -> void:
	_initialize_terrain()

	_update_size()

	_initialize_locations()
	_initialize_grid()
	_initialize_transitions()

func get_viewport_mouse_position() -> Vector2:
	"""
	Function to catch the internal viewport mouse position
	Workaround for bug https://github.com/godotengine/godot/issues/32222
	"""
	var offset_position := Vector2()
	if get_tree().current_scene.name == 'Game' || get_tree().current_scene.name == 'Editor':
		var zoom = get_tree().current_scene.get_camera_zoom() # We need to adjust the mouse cursor further by the camera's zoom level
		offset_position = get_tree().current_scene.get_global_mouse_position() - get_viewport_transform().origin
		offset_position *= zoom
	else:
		offset_position = get_local_mouse_position()
	return offset_position

func _input(event) -> void:
	if event is InputEventMouseMotion:  # If the mouse is moving, we update the highlight position on the map.
		var cell := world_to_map(get_viewport_mouse_position())

		# TODO: also hide on borders
		if not rect.has_point(cell):
			hover.hide()
		else:
			hover.show() # If the hex is over a playable hex, show the hex highlight
			hover.position = map_to_world_centered(cell)
			$Hover/HexDebug/HexCubeLoc.text = str(locations_dict[cell].cube_coords) # Debug

func map_to_world_centered(cell: Vector2) -> Vector2:
	"""
	Function to get the center of the hex
	It maps the provided tilemap (Vector2) position to the world (i.e mouse position),
	then it offsets it by half the size of the cell so that the mouse position falls where the hex is expected to start.
	"""
	return map_to_world(cell) + OFFSET

func world_to_world_centered(cell: Vector2) -> Vector2:
	"""
	Function to get the world (i.e. mouse) position of the center of the hexcell over which the mouse is currently positioned on.
	"""
	return map_to_world_centered(world_to_map(cell))

func find_path(start_loc: Location, end_loc: Location) -> Array:
	var loc_path := []
	var cell_path: PoolVector2Array = grid.find_path_by_location(start_loc, end_loc)
	if cell_path.size() > 0:
		cell_path.remove(0)
		for cell in cell_path:
			loc_path.append(get_location(cell))

	return loc_path

func extend_viewable(unit: Unit) -> bool:
	"""
	Description WiP
	"""
	var new_unit_found  = false
	#var extend_hexes := []
	#update_weight(unit, false, true)
	var cells := Hex.get_cells_around(unit.location.cell, unit.type.moves, Vector2(rect.size.x, rect.size.y))
	cells.invert()
	var cur_index = 0
	var check_radius = unit.type.moves
	var no_change = true
	var next_cutoff = check_radius * 6
	for cell in cells:
		var loc = get_location(cell)
		if not unit.side.viewable.has(loc):
			no_change = false
			var path: Array = find_path(unit.location, loc)
			var cost := 0
			for path_cell in path:
				var cell_cost = grid.get_point_weight_scale(locations_dict[path_cell.cell].id)
				if cost + cell_cost > unit.type.moves:
					break
				cost += cell_cost
				if not unit.side.viewable.has(path_cell):
					unit.side.viewable[path_cell] = 1
					if path_cell.unit:
						if not path_cell.unit.side == unit.side:
							new_unit_found = true
							unit.side.viewable_units[path_cell.unit] = 1
					#extend_hexes.append(path_cell)
				if cost == unit.type.moves:
					break
		cur_index += 1
		if cur_index == next_cutoff:
			if no_change:
				break
			check_radius -= 1
			next_cutoff += check_radius * 6
			no_change = true

	#return extend_hexes
	return new_unit_found

#seprate wrapper function for "find_all_reachable_cells" since threads can only handle 1 argument being passed for some reason
func threadable_find_all_reachable_cells(arg_array: Array) -> Dictionary:
	"""
	Method which to call find_all_reachable_cells() in a spawned thread.
	"""
	if arg_array.size() == 0:
		return {}
	var unit = arg_array[0]
	var ignore_units = false if arg_array.size()  <= 1 else arg_array[1]
	var ignore_moves = false if arg_array.size()  <= 2 else arg_array[2]
	return find_all_reachable_cells(unit,ignore_units,ignore_moves)

func find_all_reachable_cells(unit: Unit, ignore_units: bool = false, ignore_moves: bool = false) -> Dictionary:
	"""
	Method to return all hexes which are in range to a unit's movement
	* unit holds the unit instance we're checking for
	* ignore_units and ignore_moves are set to true when we only want to check the line of sight.
	* Setting them to true makes the calculations here ignore stopping due to having units on the way or less movement than max.
	"""
	update_weight(unit, false, ignore_units) # We update how much each hex costs to move for this unit
	var paths := {} # A dictionary of possible paths.
					# Each key is a location object.
					# Each value is an array of locations that this unit's would have to move through to reach the location at the key
	paths[unit.location] = []

	if unit.has_attacked:
		return paths

	var radius = (unit.type.moves if ignore_moves else unit.moves_current) # Figure out how many hexes around this unit can reach.
	var cells := Hex.get_cells_around(unit.location.cell, radius, Vector2(rect.size.x, rect.size.y)) # Figure out which exact hexes are in this radius
	if cells.size() == 0:
	# if our radius was 0, it means that our unit might be in surrounded by Zones of Control
	# In that case, we add each enemy unit which set out possible path to only the units which are in this units ZoC
		if ZOC_tiles.has(unit.location):
			for enemy_cell in ZOC_tiles[unit.location]:
				paths[enemy_cell] = [enemy_cell]
	cells.invert()
	for cell in cells: # We start finding paths for each of the possible hexes our unit could reach.
		if paths.has(cell): # To avoid duplicates
			continue
		var path: Array = find_path(unit.location, get_location(cell)) # Find the optimal path between our unit and the current hex we're checking
		if path.empty():
			continue
		var actual_path := [] # It will hold how many of the locations in this potential path, this unit is actually able to traverse with its available movement.
		var cost := 0 # Holds how much movement points it will cost in total to move through this path
		for path_location in path: # For each potential hex in this path, we calculate its difficulty
			var cell_cost = grid.get_point_weight_scale(locations_dict[path_location.cell].id)
			#if ZOC_tiles.has(path_cell) and not ignore_units:
			#	cell_cost = 1
			if cost + cell_cost > radius: # If the cost to move to the next hex in the path would exceed this unit's movement radius, we stop.
				break
			cost += cell_cost # We increment how many movement points we've spent until now to reach this hex in the path.
			actual_path.append(path_location) # If the cost to move to the next location in the path is still within this unit's movement points
			# we add this location to the actually available locations in that path
			paths[path_location] = actual_path.duplicate(true) # We keep resetting the actual distance we calculated this unit will reach towards this location.
			if cost == radius: # If the movement points we've used are exactly equal to our movement range
				# Then we still want to allow the unit to be able to attack any adjacent enemy at the end of its range
				if ZOC_tiles.has(path_location) and not ignore_units:
					var attack_path = actual_path.duplicate(true)
					for enemy_cell in ZOC_tiles[path_location]:
						if not paths.has(enemy_cell):
							attack_path.append(enemy_cell)
							paths[enemy_cell] = attack_path.duplicate(true)
							attack_path.pop_back()
				break
	return paths

func update_terrain_from_map_data(map_data: Dictionary) -> void:
	pass

func update_terrain() -> void:
	_update_locations()
	transitions.update_transitions()

func update_weight(unit: Unit, ignore_ZOC: bool = false, ignore_units: bool = false) -> void:
	"""
	This method takes as arguments a unit object
	then it calculates how many movement points each hex on the max requires for this unit to move into it
	If ignore_ZOC is true, then this unit will ignore Zones of Control of enemy units when calculating movement costs
	If ignore_units is true, then this unit will be considered able to pass through other units (useful for checking line of sight)
	"""
	for loc in ZOC_tiles.keys():
		grid.unblock_location(loc)
		for val in ZOC_tiles[loc]:
			grid.unblock_location(val)
	if not ignore_units: 	# When we're not checking line of sight
							# we're going to use this opportunity of going through each map location,
							# to update our Zones of Control dictionary
		ZOC_tiles.clear()

	for location in locations_dict.values(): # We start going through all the location objects on the map
		var cost: int = unit.get_movement_cost(location) # We get the cost to move into a specific terrain based on the unit type
		if not ignore_units and location.unit: # If the current location we're checking has a unit...
			if not location.unit.side.number == unit.side.number: # ...And that unit is hostile...
				cost = 1 # ...Then this location is always considered to cost 1 to move to (i.e. terrain costs are ignored on attacks)
				grid.make_location_one_way(location) # For pathfinding purposes, enemy unit's locations allow you to move in (i.e. attack), but not out of.
				if ignore_ZOC:
					ZOC_tiles[location]=[]
				else: # If there's no units in the location we're checking then we take the opportunity to refresh grid connection
					for adjacent_location in location.get_adjacent_locations(): # We iterate through each location around the current location we're checking
						if not _is_cell_in_map(adjacent_location.cell):
							continue
						if unit.location != adjacent_location: # If that adjacent location does not contain our unit, then we refresh all connections to it
							grid.block_location(adjacent_location)
							for neighbor_location in adjacent_location.get_adjacent_locations():
								if not _is_cell_in_map(neighbor_location.cell):
									continue
								#if (new_neighbor in neighbors and unit.location.cell == new_neighbor):
								#	continue
								elif neighbor_location == location:
									if not adjacent_location.unit or adjacent_location.unit == unit:
										grid.connect_points(adjacent_location.id,neighbor_location.id,false)
								elif not unit.location == neighbor_location and neighbor_location in ZOC_tiles.keys():
									if grid.are_points_connected(neighbor_location.id,adjacent_location.id):
										grid.disconnect_points(neighbor_location.id,adjacent_location.id)
								else:
									grid.connect_points(neighbor_location.id,adjacent_location.id,false)
						else:
							if not grid.are_points_connected(adjacent_location.id,location.id):
								grid.connect_points(adjacent_location.id,location.id,false)
						if ZOC_tiles.has(adjacent_location):
							ZOC_tiles[adjacent_location].append(location)
						else:
							ZOC_tiles[adjacent_location] = [location]

		grid.set_point_weight_scale(location.id, cost)

func set_size(size: Vector2) -> void:
	rect.size = size

	_initialize_locations()
	_initialize_grid()


func set_tile(id: int) -> void:
	"""
	Sets tile in current mouse position
	"""

	var cell: Vector2 = world_to_map(get_viewport_mouse_position())

	if not _is_cell_in_map(cell):
		return

	var code: String = tile_set.tile_get_name(id)

	# If an invalid tile ID was given, clear both base and overlay.
	# If an valid overlay tile was given, reset base to default if empty and set overlay.
	# If a valid base tile was given, simply set the base and leave the overlay alone.
	if id == INVALID_CELL:
		set_cellv(cell, id)
		overlay.set_cellv(cell, id)
	elif code.begins_with("^"):
		reset_if_empty(cell)
		overlay.set_cellv(cell, id)
	else:
		set_cellv(cell, id)

	_update_size()
	transitions.add_changed_tile(cell)

func get_village_count() -> int:
	return overlay.get_used_cells_by_id(overlay.tile_set.find_tile_by_name("^Vh")).size()

func get_location(cell: Vector2) -> Location:
	"""
	Returns the location object corresponding to a tilemap cell
	"""
	if not _is_cell_in_map(cell):
		return null
	return locations_dict[cell]

func get_pixel_size() -> Vector2:
	if int(rect.size.x) % 2 == 0:
		return map_to_world(rect.size) + Vector2(18, 36)
	else:
		return map_to_world(rect.size) + Vector2(18, 0)

func get_map_data() -> Dictionary:
	var map_data := {}
	for location in locations_dict.values():
		map_data[location.id] = {}
		map_data[location.id].cell = location.cell
		map_data[location.id].code = location.terrain.code
	return map_data


func _initialize_terrain() -> void:

	for terrain in map_data.values():
		set_cellv(terrain.cell, tile_set.find_tile_by_name(terrain.code[0]))

		if terrain.code.size() > 1:
			overlay.set_cellv(terrain.cell, tile_set.find_tile_by_name(terrain.code[1]))

func _initialize_locations() -> void:
	locations_dict.clear()


	for y in rect.size.y:
		for x in rect.size.x:
			var cell := Vector2(x, y)
			# Reset to default terrain if no terrain is specified
			reset_if_empty(cell, true)
			cover.set_cellv(cell, void_tile)

			var location := Location.new(cell, self)
			# Do this *after* setting `cell` member
			_update_terrain_record_from_map(location)

			locations_dict[cell] = location


	_initialize_border()

func _update_locations() -> void:
	for location in locations_dict.values():
		_update_terrain_record_from_map(location)

func _update_terrain_record_from_map(loc: Location) -> void:
	# Find the tileset tile on both layers (base and overlay)
	var b_tile := get_cellv(loc.cell)
	var o_tile := overlay.get_cellv(loc.cell)

	# Get tile names
	var b_code := tile_set.tile_get_name(b_tile)
	var o_code := tile_set.tile_get_name(o_tile) if overlay.get_cellv(loc.cell) != INVALID_CELL else ""

	if o_code.empty():
		loc.terrain = Terrain.new([Registry.terrain[b_code]])
	else:
		loc.terrain = Terrain.new([Registry.terrain[b_code], Registry.terrain[o_code]])

func _initialize_grid() -> void:
	grid = Grid.new(self, rect)

func _initialize_border() -> void:
	border.rect_size = get_pixel_size()

func _update_size() -> void:
	reset_if_empty(Vector2(0, 0))
	rect = get_used_rect()

func _initialize_transitions() -> void:
	transitions.initialize(self)

func _is_cell_in_map(cell: Vector2) -> bool:
	return rect.has_point(cell)

func get_location_from_mouse() -> Location:
	return get_location(world_to_map(get_viewport_mouse_position()))

func display_reachable_for(reachable_locs: Dictionary) -> void:
	# "Clear" the cover map by filling in everything with the Void terrain.
	for y in rect.size.y:
		for x in rect.size.x:
			cover.set_cell(x, y, void_tile)

	# Nothing to show, hide the map and bail.
	if reachable_locs.empty():
		cover.hide()
		return

	# Punch out visible area
	for loc in reachable_locs:
		cover.set_cellv(loc.cell, INVALID_CELL)

	cover.show()

func update_highlight(location_to_highlight : Array) -> void:
	# clear any previous highlight
	clear_highlight()

	if location_to_highlight.empty():
		return

	for location in location_to_highlight:
		highlight.set_cellv(location.cell, void_tile)

	highlight.show()

func clear_highlight() -> void:
	for y in rect.size.y:
		for x in rect.size.x:
			highlight.set_cell(x, y, -1)
	highlight.hide()

func reset_if_empty(cell: Vector2, clear_overlay: bool = false) -> void:
	if get_cellv(cell) == INVALID_CELL:
		set_cellv(cell, default_tile)

		if clear_overlay:
			overlay.set_cellv(cell, INVALID_CELL)

func debug():
	$Hover/HexDebug.visible = not $Hover/HexDebug.visible

	#for location in locations_dict.values():
		#var label: Label = Label.new()
		#label.text = str(location.id)
		#label.set_position(location.position)
		#labels.append(label)
		#add_child(label)

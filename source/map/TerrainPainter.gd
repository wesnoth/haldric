extends Node2D
class_name TerrainPainter

# small helper class for multi direction transitions
class FlagsArray:
	var content := []

	func add(flag: String) -> void:
		content[-1].append(flag)

	func create(flag: String) -> void:
		content.append([flag])

	func pop() -> String:
		return content.pop_front()

	func make_string(flags: Array) -> String:
		var s := ""
		for flag in flags:
			s += "-" + flag
		return s

	func to_string() -> String:
		var s := ""
		for flags in content:
			s += " | "
			for flag in flags:
				if flag:
					s += "-"
				s += flag
		return s


const DIRECTIONS = [  "n", "ne", "se", "s", "sw", "nw"]
const DIRECTIONS_TOP_BOTTOM = ["n", "nw", "ne", "sw", "se", "s"]

const TOWER_OFFSETS = [
	[ Vector2(-18, -36), Vector2(18, -36) ],
	[ Vector2(-18, -36), Vector2(-36, 0) ],
	[ Vector2(18, -36), Vector2(36, 0) ],
	[ Vector2(-36, 0), Vector2(-18, 36) ],
	[ Vector2(36, 0), Vector2(18, 36) ],
	[ Vector2(-18, 36), Vector2(18, 36) ],
]

var RNG = RandomNumberGenerator.new()

var locations := {}

func _draw() -> void:
	RNG = RandomNumberGenerator.new()
	RNG.seed = 10

	for cell in locations:
		var loc : Location = locations[cell]
		_set_location_base(loc)
		_set_location_transition(loc)
		_set_location_overlay(loc)

	for cell in locations:
		var loc : Location = locations[cell]
		_set_location_castle(loc)


func _set_location_base(loc: Location) -> void:

	var data : TerrainData = Data.terrains[loc.terrain.get_base_code()]

	if not data.graphic.variations:
		draw_texture(data.graphic.texture, loc.position - Hex.OFFSET + data.graphic.offset)
		return

	var variations = data.graphic.get_textures()

	draw_texture(variations[RNG.randi() % variations.size()], loc.position - Hex.OFFSET + data.graphic.offset)


func _set_location_overlay(loc: Location) -> void:

	if not Data.terrains.has(loc.terrain.get_overlay_code()):
		return

	var data : TerrainData = Data.terrains[loc.terrain.get_overlay_code()]

	if not data.graphic.variations:
		draw_texture(data.graphic.texture, loc.position - Hex.OFFSET + data.graphic.offset)
		return

	var variations = data.graphic.get_textures()

	draw_texture(variations[RNG.randi() % variations.size()], loc.position - Hex.OFFSET + data.graphic.offset)


func _set_location_transition(loc: Location) -> void:
	var code = loc.terrain.get_base_code()

	var direction := 0

	var flags_array = _get_flags_array(loc)

	# print(flags_array.to_string())

	for n_loc in loc.get_all_neighbors():

		if not n_loc or n_loc.terrain.get_base_code() == code or loc.terrain.layer >= n_loc.terrain.layer:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if not Data.transitions.has(n_code):
			direction += 1
			continue

		var n_data : Array = Data.transitions[n_code]

		for g in n_data:

			var n_graphic : TerrainTransitionGraphicData = g

			if n_graphic.exclude.has(code):
				continue

			elif not n_graphic.include or n_graphic.include.has(code):
				var transition_name = "-" + DIRECTIONS[direction]

				if not n_graphic.textures.has(transition_name):
					continue

				draw_texture(n_graphic.textures[transition_name], loc.position - Hex.OFFSET)

		direction += 1


func _set_location_castle(loc: Location) -> void:

	if not Data.wall_towers.has(loc.terrain.get_base_code()):
		return

	var segment_data : Dictionary = Data.wall_segments[loc.terrain.get_base_code()]

	var tower_graphic : CastleWallTowerGraphicData = Data.wall_towers[loc.terrain.get_base_code()]

	var direction := 0

	for n_loc in loc.get_all_neighbors_top_bottom():

		if loc.terrain.get_base_code() == n_loc.terrain.get_base_code():
			direction += 1
			continue

		var segment_graphic : CastleWallSegmentGraphicData = segment_data[DIRECTIONS_TOP_BOTTOM[direction]]

		draw_texture(tower_graphic.texture, loc.position + TOWER_OFFSETS[direction][0] + tower_graphic.offset)

		draw_texture(segment_graphic.texture, n_loc.position - Hex.OFFSET + segment_graphic.offset)

		draw_texture(tower_graphic.texture, loc.position + TOWER_OFFSETS[direction][1] + tower_graphic.offset)

		direction += 1


func _get_flags_array(loc: Location) -> FlagsArray:
	var flags := FlagsArray.new()

	var last_code := ""
	var direction := 0

	for n_loc in loc.get_all_neighbors():

		if not n_loc:
			flags.create("")
			last_code = ""
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if n_code != last_code:
			flags.create(DIRECTIONS[direction])
		else:
			flags.add(DIRECTIONS[direction])

		last_code = n_code

		direction += 1

	return flags

extends Node2D
class_name TerrainPainter

# small helper class for multi direction transitions
class FlagsArray:
	var content := []

	func _init(loc: Location) -> void:
		var last_code := ""
		var direction := 0
		for n_loc in loc.get_all_neighbors():
			if not n_loc:
				create("")
				last_code = ""
				direction += 1
				continue
			var n_code = n_loc.terrain.get_base_code()
			if n_code != last_code:
				create(DIRECTIONS[direction])
			else:
				add(DIRECTIONS[direction])
			last_code = n_code
			direction += 1

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

var _width := 0
var _height := 0

var locations := {}
var texture_data := {}


func initialize(width: int, height: int) -> void:
	_width = width
	_height = height
	clear()


func clear() -> void:
	for y in _height:
		for x in _width:

			texture_data[Vector2(x, y)] = {
				"terrains": [],
				'decorations': [],
				"transitions": [],
				"overlays": [],
				"castles": [],
			}


func change_location_graphics(loc: Location) -> void:
	_set_location_base(loc)
	_set_location_transition(loc)
	_set_location_decoration(loc)
	_set_location_overlay(loc)
	_set_location_castle(loc)


func _draw() -> void:

	for y in _height:
		for x in _width:
			var cell = Vector2(x, y)

			for entry in texture_data[cell].terrains:
				draw_texture(entry.texture, entry.position)

			for entry in texture_data[cell].transitions:
				draw_texture(entry.texture, entry.position)

	for y in _height:
		for x in _width:
			var cell = Vector2(x, y)

			for entry in texture_data[cell].decorations:
				draw_texture(entry.texture, entry.position)

	for y in _height:
		for x in _width:
			var cell = Vector2(x, y)

			for entry in texture_data[cell].overlays:
				draw_texture(entry.texture, entry.position)

	for y in _height:
		for x in _width:
			var cell = Vector2(x, y)

			for entry in texture_data[cell].castles:
				draw_texture(entry.texture, entry.position)


func _set_location_base(loc: Location) -> void:
	texture_data[loc.cell].terrains.clear()

	var data : TerrainData = Data.terrains[loc.terrain.get_base_code()]

	if not data.graphic.variations:
		texture_data[loc.cell].terrains.append({
			"texture": data.graphic.texture,
			"position": loc.position - Hex.OFFSET + data.graphic.offset
		})
		return

	var variations = data.graphic.get_textures()

	texture_data[loc.cell].terrains.append({
		"texture": variations[Hash.rand[loc.cell].ai % variations.size()],
		"position": loc.position - Hex.OFFSET + data.graphic.offset
	})


func _set_location_overlay(loc: Location) -> void:
	texture_data[loc.cell].overlays.clear()

	if not Data.terrains.has(loc.terrain.get_overlay_code()):
		return

	var data : TerrainData = Data.terrains[loc.terrain.get_overlay_code()]

	if not data.graphic.variations:
		texture_data[loc.cell].overlays.append({
			"texture": data.graphic.texture,
			"position": loc.position - Hex.OFFSET + data.graphic.offset
		})
		return

	var variations = data.graphic.get_textures()

	texture_data[loc.cell].overlays.append({
		"texture": variations[Hash.rand[loc.cell].ai % variations.size()],
		"position": loc.position - Hex.OFFSET + data.graphic.offset
	})


func _set_location_decoration(loc: Location) -> void:
	texture_data[loc.cell].decorations.clear()

	var code = loc.terrain.get_base_code()

	if Data.decorations.has(code):
		var graphic : TerrainDecorationGraphicData = Data.decorations[code]

		texture_data[loc.cell].decorations.append({
			"texture": graphic.textures[Hash.rand[loc.cell].ai % graphic.textures.size()],
			"position": loc.position - Hex.OFFSET + graphic.offset
		})


func _set_location_transition(loc: Location) -> void:
	texture_data[loc.cell].transitions.clear()

	var code = loc.terrain.get_base_code()

	var direction := 0

	var flags_array = FlagsArray.new(loc)

	for n_loc in loc.get_all_neighbors():

		if not n_loc or n_loc.terrain.get_base_code() == code or loc.terrain.layer > n_loc.terrain.layer:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if not Data.transitions.has(n_code):
			direction += 1
			continue

		var n_data : Array = Data.transitions[n_code]

		for g in n_data:

			var n_graphic : TerrainTransitionGraphicData = g

			if n_graphic.allow_drawing(code):

				var transition_name = "-" + DIRECTIONS[direction]

				if not n_graphic.textures.has(transition_name):
					continue

				texture_data[loc.cell].transitions.append({
					"texture": n_graphic.textures[transition_name],
					"position": loc.position - Hex.OFFSET
				})

		direction += 1


func _set_location_castle(loc: Location) -> void:
	texture_data[loc.cell].castles.clear()

	var code = loc.terrain.get_base_code()

	if not Data.wall_towers.has(code):
		return

	var segment_data : Dictionary = Data.wall_segments[code]
	var tower_graphic : CastleWallTowerGraphicData = Data.wall_towers[code]

	var direction := 0
	var last_code := ""

	for n_loc in loc.get_all_neighbors_top_bottom():

		if not n_loc:
			direction += 1
			continue

		var n_code = n_loc.terrain.get_base_code()

		if code == n_code:
			direction += 1
			continue

		var segment_graphic : CastleWallSegmentGraphicData = segment_data[DIRECTIONS_TOP_BOTTOM[direction]]

		if segment_graphic.allow_drawing(n_code) and direction < 5:
			texture_data[loc.cell].castles.append({
				"texture": tower_graphic.texture,
				"position": loc.position + TOWER_OFFSETS[direction][0] + tower_graphic.offset
			})

		if tower_graphic.allow_drawing(n_code):
			texture_data[loc.cell].castles.append({
				"texture": segment_graphic.texture,
				"position": n_loc.position - Hex.OFFSET + segment_graphic.offset
			})

		if segment_graphic.allow_drawing(n_code) and direction > 0:
			texture_data[loc.cell].castles.append({
				"texture": tower_graphic.texture,
				"position": loc.position + TOWER_OFFSETS[direction][1] + tower_graphic.offset
			})

		direction += 1

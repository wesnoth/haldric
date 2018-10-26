extends Node2D

var turn = 1

var sides = []

var active_side = 1

var active_unit = null
var active_unit_path = []

var terrain

var base_color_map = [
	Color("F49AC1"),
	Color("3F0016"),
	Color("55002A"),
	Color("690039"),
	Color("7B0045"),
	Color("8C0051"),
	Color("9E005D"),
	Color("B10069"),
	Color("C30074"),
	Color("D6007F"),
	Color("EC008C"),
	Color("EE3D96"),
	Color("EF5BA1"),
	Color("F172AC"),
	Color("F287B6"),
	Color("F6ADCD"),
	Color("F8C1D9"),
	Color("FAD5E5"),
	Color("FDE9F1")
]

var team_color_data = {
	"red":[Color("FF0000"),Color("FFFFFF"),Color("000000"),Color("FF0000")],
	"blue":[Color("2E419B"),Color("FFFFFF"),Color("0F0F0F"),Color("0000FF")]
}


const SHADER = preload("res://TeamColors.shader")

onready var combat_handler = $"CombatHandler"

onready var map = $"Map"
onready var units = $"UnitContainer"

onready var attack_popup = $"Interface/HUD/AttackPopup"

func _ready():
	UnitRegistry.load_dir("res://units/config")
	UnitRegistry.validate_advancements()
	
	map.add_child(MapLoader.load_map("res://maps/testMap.map"))
	terrain = map.get_child(0)
	terrain.game = self
	
	attack_popup.connect("id_pressed", self, "on_attack_popup_id_pressed")

	var Side = preload("res://game/Side.gd")
	
	sides.append(Side.new())
	sides.append(Side.new())
	
	sides[0].initialize(1, "red", 100)
	sides[1].initialize(2, "blue", 120)
	sides[0].shader = generate_team_shader(team_color_data[sides[0].color])
	sides[1].shader = generate_team_shader(team_color_data[sides[1].color])
	#pallete(team_color_data[sides[0].color])
	create_unit("Elvish Fighter", 1, 10, 1);
	create_unit("Elvish Archer", 1, 11, 1);
	create_unit("Elvish Scout", 1, 9, 1);
	create_unit("Elvish Shaman", 1, 8, 1);
	
	create_unit("Orcish Grunt", 2, 10, 13);
	create_unit("Orcish Archer", 2, 9, 13);
	create_unit("Orcish Assassin", 2, 11, 13);
	create_unit("Troll Whelp", 2, 12, 13);

var unit

func _input(event):
	if active_unit:
		var mouse_cell = terrain.world_to_map(get_global_mouse_position())
		var unit_cell = terrain.world_to_map(active_unit.position)
		active_unit_path = terrain.find_path_by_cell(unit_cell, mouse_cell)

	if Input.is_action_just_pressed("mouse_left"):
		var mouse_cell = terrain.world_to_map(get_global_mouse_position())

		if (terrain.check_boundaries(mouse_cell)):
			print("Village: ", terrain.tiles[terrain.flatten_v(mouse_cell)].is_village)
		if is_unit_at_cell(mouse_cell) and active_unit == null:
			active_unit = get_unit_at_cell(mouse_cell)

		elif is_unit_at_cell(mouse_cell) and active_unit != null:
			unit = get_unit_at_cell(mouse_cell)

			if can_fight(active_unit, unit):

				attack_popup.add_attacks(active_unit.attacks)
				attack_popup.show()

		elif !is_unit_at_cell(mouse_cell) and active_unit and !is_cell_blocked(mouse_cell) and active_side == active_unit.side:
			var tile_path = []

			for cell in active_unit_path:
				tile_path.append(terrain.tiles[terrain.flatten_v(cell)])
			if tile_path.size() > 0:
				active_unit.move(tile_path)

	if Input.is_action_just_pressed("mouse_right"):
		unit = null
		active_unit = null
		active_unit_path = []
		attack_popup.clear()
		attack_popup.hide()

func create_unit(id, side, x, y):
	var unit = UnitRegistry.create(id, side)
	unit.position = terrain.map_to_world_centered(Vector2(x, y))
	unit.game = self
	unit.set_material(sides[side-1].shader)
	units.add_child(unit)

func is_unit_at_cell(cell):
	var pos = terrain.map_to_world_centered(cell)
	for u in units.get_children():
		if u.position == pos:
			return true
	return false

func is_cell_blocked(cell):
	if terrain.check_boundaries(cell):
		return terrain.tiles[terrain.flatten_v(cell)].is_blocked

func get_unit_at_cell(cell):
	var pos = terrain.map_to_world_centered(cell)
	for u in units.get_children():
		if u.position == pos:
			return u
	return null

func get_unit_at_position(unit_position):
	for u in units.get_children():
		if u.position == unit_position:
			return u
	return null

func get_terrain_type_at_cell(cell):
	if terrain.check_boundaries(cell):
		return terrain.tiles[terrain.flatten_v(cell)].terrain_type
	else:
		return null

func get_current_side():
	return sides[active_side-1]

func can_fight(unit1, unit2):
	if active_side == unit1.side:
		if unit1.side != unit2.side:
			if unit1.can_attack:
				var unit1_cell = terrain.world_to_map(unit1.position)
				var unit2_cell = terrain.world_to_map(unit2.position)
				if terrain.are_neighbors(unit1_cell, unit2_cell):
					return true
	return false

func on_attack_popup_id_pressed(id):
	var attacker_defense = active_unit.get_defense(get_terrain_type_at_cell(terrain.world_to_map(active_unit.position)))
	var defender_defense = unit.get_defense(get_terrain_type_at_cell(terrain.world_to_map(unit.position)))
	
	var defend_id = 0
	var index = 0
	for attack in unit.attacks:
		if attack.range == active_unit.attacks[id].range:
			defend_id = index
			break
		index += 1
	
	var attacker_info = {
		attack = active_unit.attacks[id],
		defense = active_unit.get_defense(get_terrain_type_at_cell(terrain.world_to_map(active_unit.position)))
	}
	
	var defender_info = {
		attack = unit.attacks[defend_id],
		defense = unit.get_defense(get_terrain_type_at_cell(terrain.world_to_map(unit.position)))
	}
	
	combat_handler.start_fight(active_unit, attacker_info, unit, defender_info)
	
	if active_unit:
		active_unit = null
		active_unit_path = []

func end_turn():
	active_side = (active_side % sides.size()) + 1
	
	for u in units.get_children():
		if u.side == active_side:
			if u.current_moves == u.base_max_moves and u.current_health < u.base_max_health:
				u.heal(get_current_side().heal_on_rest)
			if terrain.tiles[terrain.flatten_v(terrain.world_to_map(u.position))].is_village:
				u.heal(get_current_side().heal_on_village)
			u.restore_current_moves()
	
	if active_side == 1:
		turn += 1

func generate_team_shader(team_data):
	var mat = ShaderMaterial.new()
	mat.shader = SHADER
	var color_map = new_color_map(team_data)
	var i = 1
	for key in color_map:
		mat.set_shader_param("base" + str(i),key)
		mat.set_shader_param("color" + str(i),color_map[key])
		i += 1
	return mat

func new_color_map(team_data):
	var color_map = {}

	var new_red_avg = team_data[0].r
	var new_green_avg = team_data[0].g
	var new_blue_avg = team_data[0].b
	
	var new_red_max = team_data[1].r
	var new_green_max = team_data[1].g
	var new_blue_max = team_data[1].b

	var new_red_min = team_data[2].r
	var new_green_min = team_data[2].g
	var new_blue_min = team_data[2].b

	var temp_color = base_color_map[0]

	var temp_avg = (temp_color.r + temp_color.g + temp_color.b)/3.0
	for color in base_color_map:
		var color_avg = (color.r + color.g + color.b)/3.0
		var new_color
		var r = 0
		var g = 0
		var b = 0
		if color_avg <= temp_avg:
			var ratio = color_avg/temp_avg
			r = ratio * new_red_avg + (1-ratio) * new_red_min
			g = ratio * new_green_avg + (1-ratio) * new_green_min
			b = ratio * new_blue_avg + (1-ratio) * new_blue_min

		else:
			var ratio = (1.0 - color_avg)/(1.0 - temp_avg)

			r = ratio * new_red_avg + (1-ratio) * new_red_max
			g = ratio * new_green_avg + (1-ratio) * new_green_max
			b = ratio * new_blue_avg + (1-ratio) * new_blue_max

		new_color = Color(min(r,1),min(g,1),min(b,1))
		color_map[color] = new_color
	return color_map
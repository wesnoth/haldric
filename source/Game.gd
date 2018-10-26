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

onready var recruit_popup = $"Interface/HUD/RecruitPopup"
onready var attack_popup = $"Interface/HUD/AttackPopup"

func initialize(reg_entry):
	terrain = reg_entry.map_data
	terrain.game = self
	add_child(terrain)
	
	var Side = preload("res://source/utils/Side.gd")

	for side in reg_entry.sides:
		var new_side = Side.new()
		new_side.initialize(side.side, side.gold, side.income)
		new_side.team_color = side.team_color
		new_side.team_color_info = team_color_data[side.team_color]
		new_side.shader = generate_team_shader(team_color_data[side.team_color])
		for recruit in side.recruit.split(","):
			recruit = recruit.strip_edges()
			new_side.recruit.append(recruit)
		
		sides.append(new_side)
		
		create_unit(side.type, side.side, side.position.x, side.position.z, true)

func _ready():
	Wesnoth.connect("attacker_hits", self, "on_attacker_hits")
	Wesnoth.connect("attacker_misses", self, "on_attacker_misses")
	Wesnoth.connect("defender_hits", self, "on_defender_hits")
	Wesnoth.connect("defender_misses", self, "on_defender_misses")
	Wesnoth.connect("unit_moved", self, "on_unit_moved")
	Wesnoth.connect("unit_move_finished", self, "on_unit_move_finished")
	Wesnoth.connect("turn_end", self, "on_turn_end")
	Wesnoth.connect("turn_refresh", self, "on_turn_refresh")
	
	attack_popup.connect("id_pressed", self, "on_attack_popup_id_pressed")
	recruit_popup.connect("id_pressed", self, "on_recruit_popup_id_pressed")

var unit

func _unhandled_input(event):
	if active_unit:
		var mouse_cell = terrain.world_to_map(get_global_mouse_position())
		var unit_cell = terrain.world_to_map(active_unit.position)
		active_unit_path = terrain.find_path_by_cell(unit_cell, mouse_cell)

	if event is InputEventMouseButton && event.is_action_pressed("mouse_left"):
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
		recruit_popup.clear()
		recruit_popup.hide()
	
	if Input.is_action_just_pressed("recruit"):
		if !get_current_side().leaders.size() > 0:
			print(active_side, " has no leader!")
		else:
			recruit_popup.add_recruits(get_current_side().recruit)
			recruit_popup.show()

func create_unit(id, side, x, y, is_leader = false):
	var unit = Registry.create_unit(id, side)
	unit.position = terrain.map_to_world_centered(Vector2(x, y))
	unit.game = self
	unit.set_material(sides[side-1].shader)
	unit.is_leader = is_leader
	sides[side-1].leaders.append(unit)
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

func get_side(side):
	return sides[side-1]

func can_fight(unit1, unit2):
	if active_side == unit1.side:
		if unit1.side != unit2.side:
			if unit1.can_attack:
				var unit1_cell = terrain.world_to_map(unit1.position)
				var unit2_cell = terrain.world_to_map(unit2.position)
				if terrain.are_neighbors(unit1_cell, unit2_cell):
					return true
	return false

#
# E V E N T   S I G N A L   F U N C T I O N S
#

func on_attacker_hits(event, attacker, defender):
	_handle_weapon_specials(event, attacker, defender)
	print("Event: ", event)

func on_attacker_misses(event, attacker, defender):
	print("Event: ", event)

func on_defender_hits(event, attacker, defender):
	_handle_weapon_specials(event, attacker, defender)
	print("Event: ", event)

func on_defender_misses(event, attacker, defender):
	print("Event: ", event)

func on_turn_refresh(event, side):
	_handle_abilities(event)
	
	get_current_side().turn_refresh()
	
	for u in units.get_children():
		if u.side == active_side:
			if u.current_moves == u.base_max_moves and u.current_health < u.base_max_health:
				u.heal(get_current_side().heal_on_rest)
			if terrain.tiles[terrain.flatten_v(terrain.world_to_map(u.position))].is_village:
				u.heal(get_current_side().heal_on_village)
			
			u.restore_current_moves()
			
	if active_side == 1:
		turn += 1	

func on_turn_end(event, side):
	_handle_abilities(event)
	active_side = (active_side % sides.size()) + 1
	Wesnoth.emit_signal("turn_refresh", "turn refresh", active_side)

func on_unit_moved(event, unit):
	pass

func on_unit_move_finished(unit):
	if terrain.get_tile_at_position(unit.position).is_village == true:
		_handle_village_capturing(unit)

#
# S I G N A L   F U N C T I O N S
#

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

func on_recruit_popup_id_pressed(id):
	var unit_entry = recruit_popup.get_item_metadata(id)
	
	if get_current_side().gold - unit_entry.cost <= 0:
		return
	
	if active_side == 1:
		turn += 1

	get_current_side().gold -= unit_entry.cost
	var leader_cell = terrain.world_to_map(sides[active_side-1].get_first_leader().position)
	create_unit(unit_entry.id, active_side, leader_cell.x+1, leader_cell.y)
	
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


#
# H A N D L E R   F U N C T I O N S
#

func _handle_village_capturing(unit):
	var unit_cell = terrain.world_to_map(unit.position)
	
	if terrain.get_tile_at_cell(unit_cell).is_village == true:
		
		if get_current_side().has_village(unit_cell):
			return
		
		for side in sides:
			if side.has_village(unit_cell):
				side.remove_village(unit_cell)
				side.calculate_income()
			unit.current_moves = 0
		
		get_current_side().add_village(unit_cell)
		get_current_side().calculate_income()


func _handle_weapon_specials(event, attacker, defender):
	pass


func _handle_abilities(event):
	for unit in units.get_children():
		
		if unit.side != active_side:
			continue
		
		for entry in unit.abilities:
			var ability = Registry.abilities[entry.id]	
			if ability.script.event != event:
				continue
			
			var params = {}
			
			if entry.has("params"):
				params = entry.params
			else:
				params = ability.script.default
			
			ability.function.call_func(unit, params)

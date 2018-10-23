extends Node2D

var turn = 1

var sides = []

var active_side = 1

var active_unit = null
var active_unit_path = []

var terrain

onready var combat_handler = $"CombatHandler"

onready var map = $"Map"
onready var units = $"UnitContainer"

onready var recruit_popup = $"Interface/HUD/RecruitPopup"
onready var attack_popup = $"Interface/HUD/AttackPopup"

func _ready():
	UnitRegistry.load_dir("res://units/config")
	UnitRegistry.validate_advancements()
	
	map.add_child(MapLoader.load_map("res://maps/testMap.map"))
	terrain = map.get_child(0)
	terrain.game = self
	
	Wesnoth.connect("unit_moved", self, "on_unit_moved")
	Wesnoth.connect("unit_move_finished", self, "on_unit_move_finished")
	Wesnoth.connect("end_turn", self, "on_end_turn")
	
	attack_popup.connect("id_pressed", self, "on_attack_popup_id_pressed")
	recruit_popup.connect("id_pressed", self, "on_recruit_popup_id_pressed")
	var Side = preload("res://game/Side.gd")
	
	sides.append(Side.new())
	sides.append(Side.new())
	
	sides[0].initialize(1, 100)
	sides[0].recruit = ["Elvish Fighter", "Elvish Archer", "Elvish Scout", "Elvish Shaman"]
	
	sides[1].initialize(2, 120)
	sides[1].recruit = ["Orcish Grunt", "Orcish Archer", "Orcish Assassin", "Troll Whelp"]
	
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
		recruit_popup.clear()
		recruit_popup.hide()
	
	if Input.is_action_just_pressed("recruit"):
		recruit_popup.add_recruits(get_current_side().recruit)
		recruit_popup.show()

func create_unit(id, side, x, y):
	var unit = UnitRegistry.create(id, side)
	unit.position = terrain.map_to_world_centered(Vector2(x, y))
	unit.game = self
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
	var unit_id = recruit_popup.get_item_text(id)
	if active_side == 1:
		create_unit(unit_id, active_side, 10, 0)
	if active_side == 2:
		create_unit(unit_id, active_side, 10, 15)

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

func on_end_turn(side):
	active_side = (active_side % sides.size()) + 1
	get_current_side().end_turn()
	for u in units.get_children():
		if u.side == active_side:
			if u.current_moves == u.base_max_moves and u.current_health < u.base_max_health:
				u.heal(get_current_side().heal_on_rest)
			if terrain.tiles[terrain.flatten_v(terrain.world_to_map(u.position))].is_village:
				u.heal(get_current_side().heal_on_village)
			u.restore_current_moves()
	
	if active_side == 1:
		turn += 1

func on_unit_moved(unit):
	# print(unit.id, " Moved!")
	pass

func on_unit_move_finished(unit):
	if terrain.get_tile_at_position(unit.position).is_village == true:
		_handle_village_capturing(unit)
	# print(unit.id, " Move Finished!")
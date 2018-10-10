extends Node2D

const unit_rest_heal = 2
const unit_village_heal = 8

var sides = 2
var active_side = 1

var active_unit = null
var active_unit_path = []

onready var move_handler = $"MoveHandler"
onready var terrain = $"Terrain"
onready var units = $"UnitContainer"

func _ready():
	UnitRegistry.load_dir("res://units/config")
	
	create_unit("Elvish Fighter", 1, 10, 1);
	create_unit("Elvish Archer", 1, 11, 1);
	create_unit("Elvish Scout", 1, 9, 1);
	create_unit("Elvish Shaman", 1, 8, 1);
	create_unit("Orcish Grunt", 2, 10, 13);
	create_unit("Orcish Archer", 2, 9, 13);
	create_unit("Orcish Assassin", 2, 11, 13);
	create_unit("Troll Whelp", 2, 12, 13);

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
			var unit = get_unit_at_cell(mouse_cell)
			
			if can_fight(active_unit, unit):
				active_unit.fight(unit, get_terrain_type_at_cell(terrain.world_to_map(active_unit.position)), get_terrain_type_at_cell(terrain.world_to_map(unit.position)))
				
				if active_unit.current_health < 1:
					active_unit.queue_free()
					active_unit = null
				
				if unit.current_health < 1:
					unit.queue_free()
		elif !is_unit_at_cell(mouse_cell) and active_unit and !is_cell_blocked(mouse_cell) and active_side == active_unit.side:
			move_handler.move_unit(active_unit, active_unit_path)
	
	if Input.is_action_just_pressed("mouse_right"):
		active_unit = null
		active_unit_path = []

func create_unit(type, side, x, y):
	var unit = UnitRegistry.create(type, side)
	unit.position = terrain.map_to_world_centered(Vector2(x, y))
	units.add_child(unit)

func is_unit_at_cell(cell):
	for u in units.get_children():
		if u.position == terrain.map_to_world_centered(cell):
			return true
	return false

func is_cell_blocked(cell):
	if terrain.check_boundaries(cell):
		return terrain.tiles[terrain.flatten_v(cell)].is_blocked

func get_unit_at_cell(cell):
	for u in units.get_children():
		if u.position == terrain.map_to_world_centered(cell):
			return u
	return null

func get_terrain_type_at_cell(cell):
	if terrain.check_boundaries(cell):
		return terrain.tiles[terrain.flatten_v(cell)].terrain_type
	else:
		return null

func can_fight(unit1, unit2):
	if active_side == unit1.side:
		if unit1.side != unit2.side:
			if unit1.can_attack:
				var unit1_cell = terrain.world_to_map(unit1.position)
				var unit2_cell = terrain.world_to_map(unit2.position)
				if terrain.are_neighbors(unit1_cell, unit2_cell):
					return true
	return false

func end_turn():
	active_side = (active_side % sides) + 1
	for u in units.get_children():
		if u.side == active_side:
			if u.current_moves == u.base_max_moves and u.current_health < u.base_max_health:
				u.heal(unit_rest_heal)
			if terrain.tiles[terrain.flatten_v(terrain.world_to_map(u.position))].is_village:
				u.heal(unit_village_heal)
			u.restore_current_moves()
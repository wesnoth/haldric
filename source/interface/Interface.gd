extends Node2D

export (Texture) var path_texture setget _set_path_texture

var show_grid = false

onready var game = $".."
onready var cursor = $"Cursor"

onready var sprite_builder = $"SpriteBuilder"

onready var turn_item = $"HUD/TopPanel/Turn"
onready var gold_item = $"HUD/TopPanel/Gold"
onready var income_item = $"HUD/TopPanel/Income"
onready var village_item = $"HUD/TopPanel/Villages"
onready var time_item = $"HUD/TopPanel/Time"
onready var battery_item = $"HUD/TopPanel/Battery"

onready var unit_info = $"HUD/BottomPanel/UnitItem"
onready var attack_info = $"HUD/BottomPanel/AttackInfo"

func _ready():
	$"HUD/EndTurn".connect("pressed", self, "_on_end_turn_pressed");
	

func _set_path_texture(value):
	path_texture = value
	update()

func _input(event):
	if Input.is_action_just_pressed("toggle_grid"):
		show_grid = !show_grid
		if show_grid:
			sprite_builder.show_grid(game.terrain)
		else:
			sprite_builder.remove_grid()
	if Input.is_action_just_pressed("mouse_right"):
		sprite_builder.remove_darken(game.terrain)

func _process(delta):
	update()
	update_reachable_cells()
	
	cursor.position = game.terrain.world_to_world_centered(get_global_mouse_position())
	
	turn_item.label.text = str(game.turn)
	
	gold_item.label.text = str(game.get_current_side().gold)
	income_item.label.text = str(game.get_current_side().income)
	village_item.label.text = str(game.get_current_side().villages.size(), "/", game.terrain.villages.size())
	
	var time = OS.get_time()
	time_item.label.text = str("%02d" % time.hour, ":", "%02d" % time.minute)
	battery_item.label.text = str(OS.get_power_percent_left(), "%")
	if OS.get_power_percent_left() == -1:
		battery_item.hide()
	
	var mouse_position = game.terrain.world_to_world_centered(game.get_mouse_position())
	var unit = game.get_unit_at_position(mouse_position)
	
	if unit:
		unit_info.update_unit_info(unit)
		attack_info.update_attack_info(unit.attacks)
	
	elif game.active_unit:
		unit_info.update_unit_info(game.active_unit)
		attack_info.update_attack_info(game.active_unit.attacks)

		if game.terrain.check_boundaries(game.terrain.world_to_map(get_global_mouse_position())):
			cursor.get_node("DefenseLabel").text = str(game.active_unit.get_defense(game.get_terrain_type_at_cell(game.terrain.world_to_map(get_global_mouse_position()))), " %")
		else:
			cursor.get_node("DefenseLabel").text = str("")
	else:
		unit_info.clear_unit_info()
		attack_info.clear_attack_info()
		cursor.get_node("DefenseLabel").text = str("")

func _draw():
	# draw path
	for i in range(game.active_unit_path.size()-2):
		i += 1
		draw_texture(path_texture, game.terrain.map_to_world_centered(game.active_unit_path[i]) - Vector2(36,36) ) 
		#draw_circle(game.terrain.map_to_world_centered(game.active_unit_path[i]), 5, Color(255, 0, 0))
	
	# draw villages
	for side in game.sides:
		for village in side.get_villages():
				draw_circle(game.terrain.map_to_world_centered(village), 5, Color(side.team_color_info[3]))

var last_cursor_position = Vector2(0, 0)
var last_active_unit = null
var last_active_unit_position = Vector2(0, 0)

func update_reachable_cells():
	var mouse_position = game.terrain.world_to_world_centered(get_global_mouse_position())
	var unit = game.get_unit_at_position(mouse_position)
	
	
	if last_cursor_position != mouse_position:
		if !game.active_unit:
			sprite_builder.remove_darken(game.terrain)
		if unit and !game.active_unit:
			if unit.current_moves > 0:
				game.terrain.update_weight(unit)
				sprite_builder.show_darken(game.terrain, game.terrain.get_reachable_cells_u(unit))
		last_cursor_position = mouse_position

	if game.active_unit and game.active_unit != last_active_unit:
		game.terrain.update_weight(unit)
		sprite_builder.remove_darken(game.terrain)
		sprite_builder.show_darken(game.terrain, game.terrain.get_reachable_cells_u(game.active_unit))
		last_active_unit = game.active_unit


func _on_end_turn_pressed():
	Wesnoth.emit_signal("turn_end", "turn end", game.active_side)
	turn_item.icon.set_material(game.sides[game.active_side-1].flag_shader)
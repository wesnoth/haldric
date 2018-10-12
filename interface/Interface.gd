extends Node2D

var show_grid = false

onready var game = $".."
onready var cursor = $"Cursor"

onready var sprite_builder = $"SpriteBuilder"

onready var side_label = $"HUD/GameInfo/HBox/SideLabel"
onready var turn_label = $"HUD/GameInfo/HBox/TurnLabel"

onready var unit_info = $"HUD/UnitInfo"

func _ready():
	$"HUD/EndTurn".connect("pressed", self, "_on_end_turn_pressed");

func _input(event):
	if Input.is_action_just_pressed("toggle_grid"):
		show_grid = !show_grid
		if show_grid:
			sprite_builder.show_grid(game.terrain)
		else:
			sprite_builder.remove_grid()
	if Input.is_action_just_pressed("mouse_right"):
		sprite_builder.remove_darken()

func _process(delta):
	update()
	update_reachable_cells()
	
	cursor.position = game.terrain.world_to_world_centered(get_global_mouse_position())
	side_label.text = str("Side: ", game.active_side)
	turn_label.text = str("Turn: ", game.turn)
	
	if game.active_unit:
		unit_info.update_unit_info(game.active_unit)

<<<<<<< HEAD
		if game.terrain.check_boundaries(terrain.world_to_map(get_global_mouse_position())):
			cursor.get_node("DefenseLabel").text = str(game.active_unit.get_defense(game.get_terrain_type_at_cell(terrain.world_to_map(get_global_mouse_position()))), " %")
=======
		if game.terrain.check_boundaries(game.terrain.world_to_map(get_global_mouse_position())):
			cursor.get_node("DefenseLabel").text = str(game.active_unit.get_defense(game.get_terrain_type_at_cell(game.terrain.world_to_map(get_global_mouse_position()))), " %")
>>>>>>> e452d42072a797d837e5f2bfc9fc7f70a71c6573
		else:
			cursor.get_node("DefenseLabel").text = str("")
	else:
		unit_info.clear_unit_info()
		cursor.get_node("DefenseLabel").text = str("")

func _draw():
	# draw path
	for i in range(game.active_unit_path.size()-2):
		i += 1
		draw_circle(game.terrain.map_to_world_centered(game.active_unit_path[i]), 5, Color(255, 0, 0))

var last_cursor_position = Vector2(0, 0)
var last_active_unit = null
var last_active_unit_position = Vector2(0, 0)

func update_reachable_cells():
	var mouse_position = game.terrain.world_to_world_centered(get_global_mouse_position())
	var unit = game.get_unit_at_position(mouse_position)
	
	if last_cursor_position != mouse_position:
		if !game.active_unit:
			sprite_builder.remove_darken()
		if unit and !game.active_unit:
			sprite_builder.show_darken(game.terrain, game.terrain.get_reachable_cells_u(unit))
		last_cursor_position = mouse_position

	if game.active_unit and game.active_unit != last_active_unit:
		sprite_builder.remove_darken()
		sprite_builder.show_darken(game.terrain, game.terrain.get_reachable_cells_u(game.active_unit))
		last_active_unit = game.active_unit


func _on_end_turn_pressed():
	game.end_turn()

extends Node2D

var show_grid = false

onready var game = $".."
onready var terrain = $"../Terrain"
onready var cursor = $"Cursor"
onready var grid_container = $"GridContainer"
onready var darken_container = $"DarkenContainer"

onready var side_label = $"HUD/SideLabel"
onready var unit_health_label = $"HUD/UnitInfo/HealthLabel"
onready var unit_moves_label = $"HUD/UnitInfo/MovesLabel"
onready var unit_damage_label = $"HUD/UnitInfo/DamageLabel"

func _ready():
	$"HUD/EndTurn".connect("pressed", self, "_on_end_turn_pressed");

func _input(event):
	if Input.is_action_just_pressed("toggle_grid"):
		show_grid = !show_grid
		if show_grid:
			show_grid()
		else:
			remove_grid()

func _process(delta):
	update()
	cursor.position = terrain.world_to_world_centered(get_global_mouse_position())
	side_label.text = str("Side: ", game.active_side)

	if game.active_unit:
		unit_health_label.text = str("Health: ", game.active_unit.current_health, " / ", game.active_unit.base_max_health)
		unit_moves_label.text = str("Moves: ", game.active_unit.current_moves, " / ", game.active_unit.base_max_moves)
		unit_damage_label.text = game.active_unit.get_attack_string()

		if game.terrain.check_boundaries(terrain.world_to_map(get_global_mouse_position())):
			cursor.get_node("DefenseLabel").text = str(game.active_unit.defense[game.get_terrain_type_at_cell(terrain.world_to_map(get_global_mouse_position()))], " %")
		else:
			cursor.get_node("DefenseLabel").text = str("")
	else:
		unit_health_label.text = str("Health: -")
		unit_moves_label.text = str("Moves: -")
		unit_damage_label.text = str("Attack: -")

		cursor.get_node("DefenseLabel").text = str("")

var last_cursor_position = Vector2(0, 0)
var last_active_unit = null

func _draw():	
	# draw reachable cells
	var mouse_position = terrain.world_to_world_centered(get_global_mouse_position())
	var unit = game.get_unit_at_position(mouse_position)
	
	if last_cursor_position != mouse_position:
		if not game.active_unit:
			remove_darken()
		if unit:
			show_darken(terrain.get_reachable_cells_u(unit))
		last_cursor_position = mouse_position

	if game.active_unit and game.active_unit != last_active_unit:
		remove_darken()
		show_darken(terrain.get_reachable_cells_u(game.active_unit))
		last_active_unit = game.active_unit
	
	# draw path
	for i in range(game.active_unit_path.size()-1):
		draw_circle(terrain.map_to_world_centered(game.active_unit_path[i]), 5, Color(255, 0, 0))

func show_darken(reachable):
	for cell in terrain.get_used_cells():
		if cell in reachable:
			continue
		var sprite = Sprite.new()
		sprite.texture = load("res://interface/images/darken.png")
		sprite.position = terrain.map_to_world_centered(cell)
		darken_container.add_child(sprite)

func remove_darken():
	for child in darken_container.get_children():
		child.queue_free()

func show_grid():
	for p in terrain.grid.get_points():
		var p_cell = terrain.grid.get_point_position(p)
		var sprite = Sprite.new()
		sprite.texture = load("res://interface/images/grid.png")
		sprite.position = terrain.map_to_world_centered(Vector2(p_cell.x, p_cell.y))
		grid_container.add_child(sprite)

func remove_grid():
	for child in grid_container.get_children():
		child.queue_free()

func _on_end_turn_pressed():
	game.end_turn()

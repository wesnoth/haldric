extends Node2D

onready var game = $".."
onready var terrain = $"../Terrain"
onready var cursor = $"Cursor"

onready var side_label = $"HUD/SideLabel"
onready var unit_health_label = $"HUD/UnitInfo/HealthLabel"
onready var unit_moves_label = $"HUD/UnitInfo/MovesLabel"
onready var unit_damage_label = $"HUD/UnitInfo/DamageLabel"

func _ready():
	$"HUD/EndTurn".connect("pressed", self, "_on_end_turn_pressed");

func _process(delta):
	update()
	cursor.position = terrain.world_to_world_centered(get_global_mouse_position())
	side_label.text = str("Side: ", game.active_side)
	
	if game.active_unit:
		unit_health_label.text = str("Health: ", game.active_unit.current_health, " / ", game.active_unit.base_max_health)
		unit_moves_label.text = str("Moves: ", game.active_unit.current_moves, " / ", game.active_unit.base_max_moves)
		unit_damage_label.text = game.active_unit.get_attack_string()
	else:
		unit_health_label.text = str("Health: -")
		unit_moves_label.text = str("Moves: -")
		unit_damage_label.text = str("Attack: -")

func _draw():
	# draw reachable cells
	if game.active_unit:
		for cell in terrain.get_reachable_cells_u(game.active_unit):
			var pos = terrain.map_to_world_centered(cell)
			draw_circle(pos, 5, Color(255, 255, 255))
	
	# draw path
	for i in range(game.active_unit_path.size()):
		draw_circle(terrain.map_to_world_centered(game.active_unit_path[i]), 5, Color(255, 0, 0))

func _on_end_turn_pressed():
	game.end_turn()

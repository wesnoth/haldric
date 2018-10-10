extends Node

var speed = 400

var unit
var path = []

var init_path_size = 0
var last_point

onready var game = $".."
onready var terrain = $"../Terrain"

func _process(delta):
	
	if path:
		
		if init_path_size == 0:
			init_path_size = path.size()
		
		var terrain_type = game.get_terrain_type_at_cell(path[0])
		
		var direction = get_move_direction()
		var velocity = direction * speed * delta
		
		unit.position += velocity
		
		if unit.position * direction > terrain.map_to_world_centered(path[0])  * direction:
			
			if path.size() < init_path_size:
				unit.current_moves -= 1
			
			last_point = path[0]
			path.remove(0)
			
			if !path or unit.current_moves == 0:
				
				if unit.current_moves == 0:
					path.clear()
					game.active_unit = null
					game.active_unit_path = []
				
				unit.position = terrain.world_to_world_centered(unit.position)
				unit = null
				init_path_size = 0;

func move_unit(unit, path):
	
	self.path = path
	
	if path:
		last_point = terrain.map_to_world_centered(unit.position)
		self.unit = unit


func get_move_direction():
	return (terrain.map_to_world_centered(path[0]) - terrain.map_to_world_centered(last_point)).normalized()
	
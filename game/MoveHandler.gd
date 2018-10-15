extends Node

var speed = 350.0

var unit
var path = []

var init_path_size = 0
var last_point

var velocity = Vector2(0, 0)

onready var game = $".."

func _process(delta):

	if path.size() > 1:
		var terrain_type = game.get_terrain_type_at_cell(path[1])
		if unit.current_moves - unit.get_movement_cost(terrain_type) < 0:
			unit.position = game.terrain.world_to_world_centered(unit.position)
			velocity = Vector2(0, 0)
			unit = null
			init_path_size = 0;
			path = []
			# print("path clear")

	if path.size() > 0 and unit:

		var terrain_type = game.get_terrain_type_at_cell(path[0])

		if init_path_size == 0:
			init_path_size = path.size()

		unit.position += velocity * delta

		if unit.position.distance_to(game.terrain.map_to_world_centered(path[0])) <= 6:	
			if path.size() < init_path_size:
				unit.current_moves -= unit.get_movement_cost(terrain_type)
				for adjacent_unit in unit.get_adjacent_units():
					if not adjacent_unit.side == unit.side:
						if not unit.has_moved():
							unit.current_moves = 1
						else:
							unit.current_moves = 0
						break

			last_point = path[0]
			path.remove(0)

			if path.size() == 0 or unit.current_moves == 0:

				if unit.current_moves <= 0:
					unit.current_moves = 0
					path = []
					game.active_unit = null
					game.active_unit_path = []

				unit.position = game.terrain.world_to_world_centered(unit.position)
				velocity = Vector2(0, 0)
				unit = null
				init_path_size = 0;
			else:
				var target_position = game.terrain.map_to_world_centered(path[0])
				var angle = unit.get_angle_to(target_position)
				velocity = Vector2(speed*cos(angle), speed*sin(angle))
				# print(velocity)

func move_unit(unit, path):

	self.path = path

	if path:
		last_point = game.terrain.map_to_world_centered(unit.position)
		self.unit = unit

extends Node

enum DIRECTION {SE, NE, N, NW, SW, S}

const SPEED = Vector2(150, 150)

onready var terrain = $"../Terrain"

var path = []
var unit

var last_point

func _ready():
	set_process(true)

func _process(delta):
	if path.size() != 0 and unit:
		var direction = _get_move_direction()
		var velocity = direction * SPEED * delta
		unit.position += velocity
		if unit.position * direction > terrain.map_to_world_centered(path[0]) * direction:
			print(last_point)
			last_point = path[0]
			path.remove(0)
			if path.size() == 0:
				unit = null 


# P U B L I C   F U N C T I O N S

func move_token_to_cell(_unit, _end_cell):
	var start_cell = terrain.world_to_map(_unit.position)
	move_token(_unit, terrain.find_path_by_cell(start_cell, _end_cell))

func move_unit(_unit, _path):
	path = _path
	if path.size() > 0:
		unit = _unit
		last_point = terrain.world_to_map(unit.get_position())

# P R I V A T E   F U N C T I O N S

func _get_move_direction():
	var direction = (terrain.map_to_world_centered(path[0]) - terrain.map_to_world_centered(last_point)).normalized()
	return direction

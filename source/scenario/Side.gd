extends Node
class_name Side

const INCOME_PER_VILLAGE = 2

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

var shader: ShaderMaterial = null
var flag_shader: ShaderMaterial = null

var team_color_info := []

var side := 0

var upkeep := 0

var recruit := []

var villages := []

var leaders := []

export var team_color := ""

export var base_income := 2

export var gold := 100
export var income := 2

onready var units = $Units as Node2D

func _ready() -> void:
	side = get_index() + 1

	team_color = TeamColor.team_color_data.keys()[get_index()]
	team_color_info = TeamColor.team_color_data[team_color]
	shader = TeamColor.generate_team_shader(team_color_info)
	flag_shader = TeamColor.generate_flag_shader(team_color_info)
	calculate_upkeep()
	calculate_income()

func add_village(cell: Vector2) -> void:
	villages.append(cell)

func remove_village(cell: Vector2) -> void:
	villages.erase(cell)

func has_village(cell: Vector2) -> bool:
	return villages.has(cell)

func get_villages() -> Array:
	return villages

func calculate_upkeep() -> void:
	upkeep = 0
	for unit in units.get_children():
		upkeep += unit.type.level

func calculate_income() -> void:
	income = INCOME_PER_VILLAGE * villages.size() + base_income

func turn_refresh() -> void:
	gold += income

func get_first_leader() -> Unit:
	if leaders.size() > 0:
		return leaders[0]

	return null

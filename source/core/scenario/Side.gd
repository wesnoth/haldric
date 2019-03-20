extends Node
class_name Side

const INCOME_PER_VILLAGE = 2

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

var side := 0

var team_color_info := []

export var team_color := ""

export var base_income := 2

export var gold := 100
export var income := 2

var shader: ShaderMaterial = null
var flag_shader: ShaderMaterial = null

var recruit := []

var villages := []

var leaders := []

onready var units = $Units as Node2D

func _ready() -> void:
	side = get_index()

	team_color = TeamColor.team_color_data.keys()[side]
	team_color_info = TeamColor.team_color_data[team_color]
	shader = TeamColor.generate_team_shader(team_color_info)

	calculate_income()

func add_village(cell: Vector2) -> void:
	villages.append(cell)

func remove_village(cell: Vector2) -> void:
	villages.erase(cell)

func has_village(cell: Vector2) -> bool:
	return villages.has(cell)

func get_villages() -> Array:
	return villages

func calculate_income() -> void:
	income = INCOME_PER_VILLAGE * villages.size() + base_income

func turn_refresh() -> void:
	gold += income

func get_first_leader() -> Unit:
	if leaders.size() > 0:
		return leaders[0]

	return null

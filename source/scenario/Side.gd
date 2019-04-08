extends Node
class_name Side

const Flag = preload("res://source/game/Flag.tscn")

const INCOME_PER_VILLAGE = 2

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

var shader: ShaderMaterial = null
var flag_shader: ShaderMaterial = null

var number := 0

var upkeep := 0

var recruit := []

var villages := []

var leaders := []

export var team_color := ""

export var base_income := 2

export var gold := 100
export var income := 2

onready var units = $Units as Node2D
onready var flags = $Flags as Node2D

func _ready() -> void:
	Event.connect("turn_refresh", self, "_on_turn_refresh")

	number = get_index() + 1

	team_color = TeamColor.team_color_data.keys()[get_index()]

	shader = TeamColor.generate_team_shader(team_color)
	flag_shader = TeamColor.generate_flag_shader(team_color)

	calculate_upkeep()
	calculate_income()

# :Unit
func add_unit(unit) -> void:
	units.add_child(unit)
	unit.side = self
	unit.sprite.material = shader
	calculate_upkeep()

func add_village(loc: Location) -> bool:
	if not villages.has(loc):
		villages.append(loc)
		_add_flag(loc)
		return true
	return false

func remove_village(loc: Location) -> void:
	if villages.has(loc):
		loc.flag.queue_free()
		villages.erase(loc)

func has_village(loc: Location) -> bool:
	return villages.has(loc)

func get_villages() -> Array:
	return villages

func calculate_upkeep() -> void:
	upkeep = 0
	for unit in units.get_children():
		upkeep += unit.type.level

func calculate_income() -> void:
	income = base_income + INCOME_PER_VILLAGE * villages.size() - upkeep

func turn_refresh() -> void:
	gold += income

# -> Unit
func get_first_leader():
	if leaders.size() > 0:
		return leaders[0]
	return null

func _add_flag(loc: Location) -> void:
	var flag = Flag.instance()
	flag.position = loc.position
	# flag.material = flag_shader
	loc.flag = flag
	flags.add_child(flag)

func _on_turn_refresh(turn: int, side: int) -> void:
	if self.number == side:
		calculate_upkeep()
		calculate_income()
		gold += income

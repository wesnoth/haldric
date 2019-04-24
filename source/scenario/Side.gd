extends Node
class_name Side

const Flag = preload("res://source/game/Flag.tscn")

const INCOME_PER_VILLAGE = 2

const HEAL_ON_VILLAGE = 8
const HEAL_ON_REST = 2

var unit_shader: ShaderMaterial = null
var flag_shader: ShaderMaterial = null

var number := 0

var income := 0
var upkeep := 0

var villages := []

var leaders := []

export(String, "Red", "Blue", "Green", "Purple", "Black", "White", "Brown", "Orange", "Teal") var team_color := "Red"
export(String, "Standard", "Knalgan", "Long", "Ragged", "Undead", "Wood-Elvish") var flag_type := "Standard"

export var gold := 100
export var base_income := 2

export var start_position := Vector2()

export(Array, String) var leader := [""]
export(Array, String) var random_leader := [""]
export(Array, String) var recruit := [""]

onready var units = $Units as Node2D
onready var flags = $Flags as Node2D

func _ready() -> void:
	Event.connect("turn_refresh", self, "_on_turn_refresh")

	number = get_index() + 1

	flag_type = flag_type.to_lower()
	team_color = team_color.to_lower()

	unit_shader = TeamColor.generate_team_shader(team_color)
	flag_shader = TeamColor.generate_flag_shader(team_color)

	_calculate_upkeep()
	_calculate_income()

# :Unit
func add_unit(unit) -> void:
	units.add_child(unit)
	unit.side = self
	unit.type.sprite.material = unit_shader
	_calculate_upkeep()
	_calculate_income()

func add_village(loc: Location) -> bool:
	if not villages.has(loc):
		villages.append(loc)
		_add_flag(loc)
		_calculate_upkeep()
		_calculate_income()
		return true
	return false

func remove_village(loc: Location) -> void:
	if villages.has(loc):
		loc.flag.queue_free()
		villages.erase(loc)
		_calculate_upkeep()
		_calculate_income()

func has_village(loc: Location) -> bool:
	return villages.has(loc)

# -> Unit
func get_first_leader():
	if leaders.size() > 0:
		return leaders[0]
	return null

func _calculate_upkeep() -> void:
	upkeep = 0
	for unit in units.get_children():
		upkeep += unit.type.level

func _calculate_income() -> void:
	income = base_income + INCOME_PER_VILLAGE * villages.size() - upkeep

func _turn_refresh() -> void:
	_calculate_upkeep()
	_calculate_income()
	gold += income

func _add_flag(loc: Location) -> void:

	if loc.flag:
		loc.flag.side.remove_village(loc)

	var flag = Flag.instance()

	flag.side = self
	flag.position = loc.position
	flag.material = flag_shader
	loc.flag = flag
	flags.add_child(flag)
	flag.play(flag_type)

func _on_turn_refresh(turn: int, side: int) -> void:
	if self.number == side and not turn == 1:
		_turn_refresh()

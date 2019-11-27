extends Node
class_name Side

const Flag = preload("res://source/game/Flag.tscn")

const INCOME_PER_VILLAGE = 1 # How much gold extra each village provides

const HEAL_ON_VILLAGE = 8 # Each unit starting its turn in a village heals this amount per turn
const HEAL_ON_REST = 2 # Each unit starting its turn with full movement heals this amount per turn

var unit_shader: ShaderMaterial = null
var flag_shader: ShaderMaterial = null

var income := 0 # How much gold per turn this side is making
var upkeep := 0 # How much gold per turn this side is losing

var villages := [] # List which contains locations with a village, that this side controls

var leaders := []

var viewable := {}

var viewable_units := {} #dont know if we need this, but just in case

export(String, "Red", "Blue", "Green", "Purple", "Black", "White", "Brown", "Orange", "Teal") var team_color := "Red"
export(String, "Standard", "Knalgan", "Long", "Ragged", "Undead", "Wood-Elvish") var flag_type := "Standard"

export var gold := 100 # The gold amount a side starts by default
export var base_income := 2 # The base income defined for all sides by wesnoth

export var start_position := Vector2()

export var fog := false
export var shroud := false

export(Array, String) var leader := [""]
export(Array, String) var random_leader := [""]
export(Array, String) var recruit := [""]

onready var number := get_index() + 1

onready var units = $Units as Node2D
onready var flags = $Flags as Node2D

func _ready() -> void:
	Event.connect("turn_refresh", self, "_on_turn_refresh")

	flag_type = flag_type.to_lower()
	team_color = team_color.to_lower()

	unit_shader = TeamColor.generate_team_shader(team_color)
	flag_shader = TeamColor.generate_flag_shader(team_color)

	_calculate_upkeep()
	_calculate_income()

# :Unit
func add_unit(unit) -> void:
	"""
	Adds the specified unit object and sets it to belong to this side
	Also updates gold production (for the GUI)
	"""
	units.add_child(unit)
	unit.side = self
	unit.type.sprite.material = unit_shader
	_calculate_upkeep()
	_calculate_income()

func add_village(loc: Location) -> bool:
	"""
	Checks if the side's villages list does not contain the provided location object
	If it doesn't, it appends it to the list and recalculates gold production (for the GUI)
	"""
	if not villages.has(loc):
		villages.append(loc)
		_add_flag(loc)
		_calculate_upkeep()
		_calculate_income()
		return true
	return false

func remove_village(loc: Location) -> void:
	"""
	Checks if the side's villages list contains the provided location object
	If it does, it removes it from the list and recalculates gold production (for the GUI)
	"""
	if villages.has(loc):
		loc.flag.queue_free()
		villages.erase(loc)
		_calculate_upkeep()
		_calculate_income()

func has_village(loc: Location) -> bool:
	"""
	Checks if the side's villages list contains the provided location object
	"""
	return villages.has(loc)

# -> Unit
func get_first_leader():
	if leaders.size() > 0:
		return leaders[0]
	return null

func _calculate_upkeep() -> void:
	"""
	Calculates how much gold costs the player will have.
	The default calculation is 1 per unit level they control.
	Units with loyal traits do not cost anything.
	"""
	upkeep = 0
	for unit in units.get_children():
		upkeep += unit.type.level

func _calculate_income() -> void:
	"""
	Calculates how much incoming gold the player will have.
	The default calculation is 2 + 1 per village
	"""
	income = base_income + INCOME_PER_VILLAGE * villages.size()

func _turn_refresh(first_turn: bool) -> void:
	"""
	Internal method called when this side's turn is starting.
	It makes sure the side's gold totals are correct.
	Then it modifies its gold.
	Finally it calls each units refresh function for MP and HP.
	"""
	if not first_turn:
		_calculate_upkeep()
		_calculate_income()
		gold += income - upkeep
	#viewable refresh section
	viewable.clear()
	if fog:
		for unit in units.get_children():
			unit.thread.start(unit.location.map, "threadable_find_all_reachable_cells", [unit,true,true])
			var temp = unit.thread.wait_to_finish()
			if temp:
				for loc in temp.keys():
					viewable[loc] = 1
					if loc.unit and not loc.unit.side == self:
						viewable_units[loc.unit] = 1

	for unit in units.get_children():
		if not first_turn:
			unit.refresh_unit()
		unit.set_reachable()

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
	"""
	signal hook function which triggers when a side's turn is starting
	It calls the function to refresh the side's gold and units
	"""
	if self.number == side:
		_turn_refresh(turn == 1)

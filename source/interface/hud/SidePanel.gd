extends PanelContainer

var flags := {
	"standard": Vector2(24*0, 0),
	"knalgan": Vector2(24*1, 0),
	"long": Vector2(24*2, 0),
	"loyalist": Vector2(24*3, 0),
	"ragged": Vector2(24*4, 0),
	"undead": Vector2(24*5, 0),
	"wood-elfish": Vector2(24*6, 0)
}

var scenario : Scenario = null
var side : Side = null

onready var flag_item = $HBoxContainer/Flag as SidePanelItem
onready var gold_item = $HBoxContainer/Gold as SidePanelItem
onready var villages_item = $HBoxContainer/Villages as SidePanelItem
onready var units_item = $HBoxContainer/Units as SidePanelItem
onready var upkeep_item = $HBoxContainer/Upkeep as SidePanelItem
onready var income_item = $HBoxContainer/Income as SidePanelItem
onready var battery_item = $HBoxContainer/Battery as SidePanelItem
onready var time_item = $HBoxContainer/Time as SidePanelItem

func _ready() -> void:
	var texture = AtlasTexture.new()
	texture.atlas = preload("res://graphics/images/interface/icons/flags.png")
	flag_item.texture_rect.texture = texture
	_update_battery()

func _process(delta: float) -> void:

	if scenario and side:
		update_side(scenario, side)

	time_item.set_text(_get_time_string())

func update_side(scenario : Scenario, side : Side) -> void:
	self.scenario = scenario
	self.side = side
	if scenario.turns >= 0:
		flag_item.set_text("%d / %d" % [scenario.turn, scenario.turns])
	else:
		flag_item.set_text(str(scenario.turn))

	flag_item.texture_rect.material = side.flag_shader
	flag_item.texture_rect.texture.region = Rect2(flags[side.flag_type], Vector2(24, 16))

	gold_item.set_text(str(side.gold))
	units_item.set_text(str(side.units.get_child_count()))
	upkeep_item.set_text(str(side.upkeep - side.villages.size()))
	upkeep_item.set_extra_text('(' + str(side.upkeep) + ')')
	villages_item.set_text("%d/%d" % [side.villages.size(), scenario.get_village_count()])
	income_item.set_text(str(side.income - side.upkeep))

func _update_battery() -> void:
	var power_percentage : int = OS.get_power_percent_left()

	if power_percentage == -1:
		battery_item.hide()
	else:
		battery_item.set_text("%d%%" % power_percentage)

func _get_time_string() -> String:
	var time = OS.get_time()
	var hour = time.hour
	var minute = time.minute
	return "%02d : %02d" % [hour, minute]

func _on_BatteryTimer_timeout() -> void:
	_update_battery()

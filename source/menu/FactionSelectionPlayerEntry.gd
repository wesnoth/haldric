extends HBoxContainer
class_name FactionSelectionPlayerEntry

onready var faction_options := $FactionOptions as OptionButton
onready var leader_options := $LeaderOptions as OptionButton
onready var ai_options := $AIOptions as OptionButton

onready var label := $Label as Label


func _ready() -> void:
	for key in Side.Controller.keys():
		ai_options.add_item(key)


func initialize(side_number: int, factions: Array) -> void:
	label.text = "Player %d" % (side_number + 1)

	for faction in factions:
		faction_options.add_item(faction)


func get_faction_key() -> String:
	return faction_options.get_item_text(faction_options.get_selected_id())

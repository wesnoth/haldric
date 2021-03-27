extends Panel


export var FactionSelectionPlayerEntry: PackedScene = null

onready var entry_container := $CenterContainer/VBoxContainer/Sides


func _ready() -> void:
	for i in Campaign.selected_scenario.map.players.size():
		var entry := FactionSelectionPlayerEntry.instance()
		entry_container.add_child(entry)
		entry.initialize(i, Data.factions.keys())


func get_selected_sides() -> Array:
	var sides := []

	for entry in entry_container.get_children():
		var faction = entry.get_faction_key()
		sides.append(Data.factions[faction])
	return sides


func _on_PlayButton_pressed() -> void:
	Campaign.selected_sides = get_selected_sides()
	Scene.change("Game")

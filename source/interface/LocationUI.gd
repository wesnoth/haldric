extends HBoxContainer
class_name LocationUI

onready var location_cell_label := $Column1/Cell
onready var terrain_code_label := $Column1/TerrainCode
onready var types_label := $Column1/Types
onready var recruit_from_label := $Column1/RecruitFrom
onready var recruit_onto_label := $Column1/RecruitOnto
onready var heals_label := $Column1/Heals
onready var town_size_label := $Column1/TownSize

onready var location_unit := $Column2/Unit


func update_info(loc: Location) -> void:
	if not loc:
		return

	location_cell_label.text = "Tile: " + str(loc.cell)
	terrain_code_label.text = "Code: " + loc.terrain.get_code()
	types_label.text = "Type: " + loc.terrain.get_type()

	recruit_from_label.text = "Recruit From: %s" % loc.terrain.recruit_from
	recruit_onto_label.text = "Recruit Onto: %s" % loc.terrain.recruit_onto
	town_size_label.text = "Town Size: %s" % loc.town.size()

	heals_label.text = "Heals: %s" % loc.terrain.heals

	location_unit.text = loc.unit.type.alias if loc.unit else ""

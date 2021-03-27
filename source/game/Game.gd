extends Node2D

var scenario : Scenario = null

var hovered_location : Location = null

var selected_unit : Location = null
var selected_skill : Skill = null

onready var scenario_container := $ScenarioContainer
onready var time_shader := $CanvasLayer/TimeShader

onready var UI = $GameUI as GameUI

func _ready() -> void:
	_load_scenario()


func _unhandled_input(event: InputEvent) -> void:

	if scenario.current_side.controller == Side.Controller.AI:
		return

	if event.is_action_released("RMB"):
		if selected_skill:
			_set_selected_skill(null)
		elif selected_unit and not hovered_location == selected_unit:
			_set_selected_unit(null)
		elif hovered_location:
			if hovered_location.unit and hovered_location.unit.side_number == scenario.current_side.number:
				selected_unit = hovered_location
			else:
				selected_unit = null

			UI.show_action_dialogue(hovered_location, scenario.current_side)

	elif event.is_action_released("LMB"):
		_handle_location_selection(hovered_location)

	elif event.is_action_pressed("recruit"):
		if scenario.current_side.can_recruit():
			UI.show_recruit_dialogue(scenario.current_side, null)

	elif event.is_action_pressed("recall"):
		if scenario.current_side.can_recruit():
			UI.show_recall_dialogue(scenario.current_side, null)

	elif event.is_action_pressed("end_turn") and not selected_unit and not scenario.is_side_moving:
		scenario.end_turn()


func _handle_location_selection(loc: Location) -> void:

	if not loc:
		return


	if selected_skill:
		if selected_skill.reach < Hex.get_cell_distance(selected_unit.cell, loc.cell):
			Console.warn("Selected Location out of reach! (%d)" % selected_skill.reach)
		else:
			selected_skill.execute(loc)
			_set_selected_skill(null)
		return

	UI.hide_action_dialogue()

	if selected_unit and _is_valid_attack_location(loc):
		var attacker = selected_unit
		var path = scenario.map.find_path(selected_unit, loc).path

		if path.size() > 1:
			var new_attacker_location = path[path.size()-2].duplicate()
			new_attacker_location.unit = attacker.unit
			attacker = new_attacker_location

		UI.show_combat_dialogue(scenario.schedule.current_time, attacker, loc)

	elif loc.unit:
		_set_selected_unit(loc)

	elif selected_unit and selected_unit.unit.side_number == scenario.current_side.number:
		scenario.move_unit(selected_unit, loc)
		_set_selected_unit(null)


func _load_scenario() -> void:
	scenario = Campaign.selected_scenario.scene.instance()
	scenario.map_data = Campaign.selected_scenario.map
	scenario.connect("location_hovered", self, "_on_Scenario_location_hovered")
	scenario.connect("show_info_dialogue", self, "_on_Scenario_show_info_dialogue")
	scenario_container.add_child(scenario)
	scenario.schedule.connect("time_changed", self, "_on_Schedule_time_changed")
	UI.set_cover_size(scenario.map.get_used_rect().size)
	Command.scenario = scenario


func _is_valid_attack_location(loc: Location) -> bool:
	if loc.unit and not scenario.map.is_location_reachable(selected_unit, loc):
		return false

	return loc.unit != null \
		and selected_unit.unit != loc.unit \
		and selected_unit.unit.team_name != loc.unit.team_name \
		and selected_unit.unit.side_number == scenario.current_side.number\
		and selected_unit.unit.can_attack()


func _set_hovered_location(loc: Location) -> void:
	hovered_location = loc

	get_tree().call_group("Selector", "update_info", loc, selected_unit)
	get_tree().call_group("LocationUI", "update_info", loc)

	if UI.shows_actions:
		return

	if selected_unit and selected_unit.unit.team_name == scenario.current_side.team_name:
		UI.show_hover_path(scenario.map.find_path(selected_unit, loc).path)
	else:
		get_tree().call_group("UnitUI", "update_info", loc)


func _set_selected_skill(skill: Skill) -> void:
	selected_skill = skill

	if selected_skill:
		UI.hide_hover_path()

	else:
		_set_selected_unit(null)


func _set_selected_unit(loc: Location) -> void:

	if selected_unit:
		UI.hide_cover()
		if selected_unit.unit:
			selected_unit.unit.deselect()

	selected_unit = loc

	if selected_unit:
		if selected_unit.unit:
			selected_unit.unit.select()
			scenario.map.update_grid_weight(selected_unit.unit)
			UI.show_cover(scenario.map.find_reachable_cells(selected_unit, selected_unit.unit).keys())
			get_tree().call_group("UnitUI", "update_info", selected_unit)
	else:
		UI.hide_hover_path()
		get_tree().call_group("UnitUI", "clear")


func _on_Scenario_location_hovered(loc: Location) -> void:
	_set_hovered_location(loc)


func _on_Scenario_show_info_dialogue(char_name, text):
	UI.show_info_dialogue(char_name, text)


func _on_Schedule_time_changed(time: Time) -> void:
	time_shader.material.set_shader_param("delta", Vector3(time.tint_red, time.tint_green, time.tint_blue))
	get_tree().call_group("ToDWidget", "update_info", time)
	print("time changd", time.name)


func _on_GameUI_combat_option_selected(attacker_attack: Attack, defender_attack: Attack, target: Location) -> void:
	scenario.start_combat(selected_unit, attacker_attack, target, defender_attack)
	_set_selected_unit(null)


func _on_GameUI_recruit_option_selected(unit_type_id, loc) -> void:
	scenario.recruit(unit_type_id, loc)


func _on_GameUI_recall_option_selected(unit_type_id, data, loc) -> void:
	scenario.recall(unit_type_id, data, loc)


func _on_GameUI_skill_selected(skill: Skill) -> void:
	_set_selected_skill(skill)


func _on_GameUI_recruit_selected(loc: Location) -> void:
	if scenario.current_side.can_recruit():
		UI.show_recruit_dialogue(scenario.current_side, loc)


func _on_GameUI_recall_selected(loc: Location) -> void:
	if scenario.current_side.can_recruit():
		UI.show_recall_dialogue(scenario.current_side, loc)


func _on_GameUI_move_selected(loc: Location) -> void:
	_set_selected_unit(loc)


func _on_GameUI_end_turn_pressed() -> void:
	if scenario.is_side_moving:
		return

	_set_selected_unit(null)
	scenario.end_turn()


func _on_GameUI_exit_button_pressed() -> void:
	Scene.change("TitleScreen")

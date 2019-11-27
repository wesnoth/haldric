extends Control

onready var team_color_rect = $HBoxContainer/TeamColorRect
onready var health_bar := $HBoxContainer/VBoxContainer/HealthBar
onready var experience_bar := $HBoxContainer/VBoxContainer/ExperienceBar

func update_unit(unit: Unit):
	health_bar.max_value = unit.type.health
	health_bar.value = unit.health_current

	experience_bar.max_value = unit.type.experience
	experience_bar.value = unit.experience_current

	team_color_rect.color = TeamColor.team_color_data[unit.side.team_color][0]

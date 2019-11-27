extends Control

onready var blade := $CenterContainer/GridContainer/Blade as HBoxContainer
onready var pierce := $CenterContainer/GridContainer/Pierce as HBoxContainer
onready var impact := $CenterContainer/GridContainer/Impact as HBoxContainer
onready var cold := $CenterContainer/GridContainer/Cold as HBoxContainer
onready var fire := $CenterContainer/GridContainer/Fire as HBoxContainer
onready var arcane := $CenterContainer/GridContainer/Arcane as HBoxContainer

func update_resistance(resistance : Resistance) -> void:
	blade.value = resistance.blade
	pierce.value = resistance.pierce
	impact.value = resistance.impact
	cold.value = resistance.cold
	fire.value = resistance.fire
	arcane.value = resistance.arcane

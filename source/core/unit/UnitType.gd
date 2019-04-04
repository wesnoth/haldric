extends Node
class_name UnitType

export var ID := ""
export var race := ""
export var alignment := ""

export var level := 1
export var cost := 1
export var health := 1
export var moves := 1
export var experience := 1

export var advances_to := ""

onready var defense = $Defense as Defense
onready var movement = $Movement as Movement
onready var resistance = $Resistance as Resistance
extends Node2D
class_name UnitType

export var id := ""
export var race := ""
export var alignment := ""

export var level := 1
export var cost := 1
export var health := 1
export var moves := 1
export var experience := 1

export var advances_to := ""

onready var defense := $Defense as Defense
onready var movement := $Movement as Movement
onready var resistance := $Resistance as Resistance

onready var attacks := $Attacks as Node

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

func _ready() -> void:
	if anim.has_animation("stand"):
		anim.play("stand")

func get_attacks() -> Array:
	return attacks.get_children()
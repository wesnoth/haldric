tool
extends Node2D
class_name UnitType

enum Usage { SCOUT, FIGHTER, ARCHER, MIXED_FIGHTER, HEALER }

const UNIT_TYPE_EFFECT = "res://source/unit/effect/EffectUnitType.gd"

export var alias = ""
export var alignment := "neutral"

export var race := ""

export var level := 0
export var cost := 1
export var health := 1
export var moves := 1
export var experience := 1

export(Array, PackedScene) var traits := []
export(Array, String) var advances_to := []

export(Usage) var usage : int = Usage.FIGHTER

onready var defense := $Defense as DefenseType
onready var movement := $Movement as MovementType
onready var resistance := $Resistance as ResistanceType

onready var abilities := $Abilities
onready var skills := $Skills
onready var attacks := $Attacks

onready var advancements := $Advancements

onready var anim := $AnimationPlayer
onready var sprite := $Sprite


func _ready() -> void:
	for id in advances_to:
		var advancement = Advancement.new()
		var effect = load(UNIT_TYPE_EFFECT).new() # cyclic dependency hack
		var unit_type = Data.units[id]
		advancements.add_child(advancement)
		advancement.add_child(effect)
		effect.type = unit_type


func _enter_tree() -> void:
	if not Engine.editor_hint:
		return

	if not $AnimationPlayer:
		anim = AnimationPlayer.new()
		anim.name = "AnimationPlayer"
		add_child(anim)
		anim.owner = get_tree().edited_scene_root
		print("Node added: %s" % anim.name)

	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)

	if not $Defense:
		defense = DefenseType.new()
		defense.name = "Defense"
		add_child(defense)
		defense.owner = get_tree().edited_scene_root
		print("Node added: %s" % defense.name)

	if not $Movement:
		movement = MovementType.new()
		movement.name = "Movement"
		add_child(movement)
		movement.owner = get_tree().edited_scene_root
		print("Node added: %s" % movement.name)

	if not $Resistance:
		resistance = ResistanceType.new()
		resistance.name = "Resistance"
		add_child(resistance)
		resistance.owner = get_tree().edited_scene_root
		print("Node added: %s" % resistance.name)

	if not $Abilities:
		abilities = Node.new()
		abilities.name = "Abilities"
		add_child(abilities)
		abilities.owner = get_tree().edited_scene_root
		print("Node added: %s" % abilities.name)

	if not $Attacks:
		attacks = Node.new()
		attacks.name = "Attacks"
		add_child(attacks)
		attacks.owner = get_tree().edited_scene_root
		print("Node added: %s" % attacks.name)

	if not $Skills:
		skills = Node.new()
		skills.name = "Skills"
		add_child(skills)
		skills.owner = get_tree().edited_scene_root
		print("Node added: %s" % skills.name)

	if not $Advancements:
		advancements = Node.new()
		advancements.name = "Advancements"
		add_child(advancements)
		advancements.owner = get_tree().edited_scene_root
		print("Node added: %s" % advancements.name)


func _get_configuration_warning() -> String:
	var warning := ""

	if name == "UnitType":
		warning += "rename root!\n"

	if not $AnimationPlayer:
		warning += "AnimationPlayer Node missing!\n"

	if not $Sprite:
		warning += "Sprite Node missing!\n"

	if not $Defense:
		warning += "Defense Node missing!\n"

	if not $Movement:
		warning += "Movement Node missing!\n"

	if not $Resistance:
		warning += "Resistance Node missing!\n"

	if not $Abilities:
		warning += "Abilities Node missing!\n"

	if not $Skills:
		warning += "Skills Node missing!\n"

	if not $Attacks:
		warning += "Attacks Node missing!\n"

	if not $Advancements:
		warning += "Advancements Node missing!\n"
	return warning

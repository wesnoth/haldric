tool
extends Node2D
class_name Projectile

export var rotate := true
export var travel_time := 0.2

onready var tween := $Tween as Tween
onready var sprite := $Sprite as Sprite


func _ready() -> void:
	if Engine.editor_hint:
		return

	tween.connect("tween_all_completed", self, "_on_impact")


func fire(source, target) -> void:
	global_position = source.position

	if rotate:
		sprite.look_at(target.position)
		sprite.rotation_degrees += 90

	tween.interpolate_property(sprite, "global_position", source.position, target.position, travel_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _enter_tree() -> void:
	if not Engine.editor_hint:
		return

	if not $Tween:
		tween = Tween.new()
		tween.name = "Tween"
		add_child(tween)
		tween.owner = get_tree().edited_scene_root
		print("Node added: %s" % tween.name)

	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)


func _get_configuration_warning() -> String:
	var warning := ""

	if not $Tween:
		warning += "Tween Node missing!\n"

	if not $Sprite:
		warning += "Sprite Node missing!\n"

	return warning


func _on_impact() -> void:
	queue_free()

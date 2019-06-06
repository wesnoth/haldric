extends State
class_name Move

var host = null
var fake_node = Node2D.new()
onready var anim = $UnitPathDisplay as UnitPathDisplay

export(float, 0.1, 1.0) var move_time := 0.15

func _ready():
	anim.tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	anim.tween.connect("tween_step", self, "_on_Tween_tween_step")
	add_child(fake_node)

func _enter(host):
	if host.type.anim.has_animation("move"):
		host.type.anim.play("move")
	self.host = host
	_move()

func _exit(host):
	self.host = null

func _update_unit_loc(loc):
	host.location.unit = null
	host.location = loc
	host.location.unit = host

func _move():
	if !host.path || !host.tween:
		return

	var idx = 0

	for loc in host.path:
		var cost = host.get_movement_cost(loc)
		if host.moves_current < cost:
			break
		# TODO: add more checks
		if loc.map.ZOC_tiles.has(loc):
			host.moves_current = 0
		else:
			host.moves_current -= cost
		idx += 1
		_update_unit_loc(loc)
		host.emit_signal("moved", host, host.location)
		host.set_reachable() # TODO: do we want this?

	host.path.resize(idx)

	var time := clamp(anim.path.size() * 0.2, 0.25, 2.5)
	anim.follow.unit_offset = 0
	anim.remote_control.remote_path = fake_node.get_path()
	anim.path = host.path
	anim.tween.interpolate_property(anim.follow, "unit_offset", 0, 1, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	anim.tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	host.position = host.location.position
	host.emit_signal("move_finished", host, host.location)
	host.change_state("idle")

func _on_Tween_tween_step(obj, key, elapsed, value):
	host.position = fake_node.position
	pass

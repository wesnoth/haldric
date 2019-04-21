extends State

var host = null

export(float, 0.1, 1.0) var move_time := 0.15

func _enter(host):
	if host.type.anim.has_animation("move"):
		host.type.anim.play("move")
	self.host = host
	_move()

func _exit(host):
	self.host = null

func _move():
	if host.path and host.tween:
		var loc: Location = host.path[0]
		var cost = host.get_movement_cost(loc)

		if cost > host.moves_current:
			return

		host.location.unit = null
		host.location = loc
		host.location.unit = host

		#warning-ignore:return_value_discarded
		host.tween.interpolate_property(host, "position", host.position, loc.position, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

		if host.location.map.ZOC_tiles.has(host.location):
			host.moves_current = 0
		else:
			host.moves_current -= cost
		host.viewable = host.location.map.find_all_viewable_cells(host)
		host.set_reachable() # TODO: do we want this?
		host.path.remove(0)
		#warning-ignore:return_value_discarded
		host.tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	host.emit_signal("moved", host, host.location)
	if host.path:
		_move()
	else:
		host.emit_signal("move_finished", host, host.location)
		host.change_state("idle")
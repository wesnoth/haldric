extends State

func _enter(host: Unit):
	if host.type.anim.has_animation("stand"):
		host.type.anim.play("stand")
		host.type.anim.advance(randf() * host.type.anim.current_animation_length)

func _exit(host):
	pass

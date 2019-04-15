extends State

func _enter(host: Unit):
	if host.type.anim.has_animation("stand"):
		host.type.anim.play("stand")

func _exit(host):
	pass
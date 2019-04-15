extends Node
class_name State

func _enter(host):
	print("Enter State: ", name)

func _exit(host):
	print("Exit State: ", name)

func input(host, event):
	pass

func update(host, delta):
	pass

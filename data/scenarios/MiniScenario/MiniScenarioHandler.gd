extends Node

func _ready():
	EventBus.add_listener("start", self, "_on_start")

func _on_start(data):
	Console.write("STARTING!!")

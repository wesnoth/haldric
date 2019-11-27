extends Control

onready var inner_circle := $InnerCircle as Circle

onready var wheel := $ToDWheel as ToDWheel

var times := []

func initialize(times: Array) -> void:
	self.times = times
	wheel.initialize(times)

func update_time(time: Time) -> void:
	inner_circle.color = time.color

extends Node

# https://godotengine.org/qa/10650/best-way-to-create-events-between-two-nodes

var listeners = {}

func _ready():
	pass

# void add_listener(object event, object, funcname)
# adds a function reference to the list of listeners for the given named event
func add_listener(event, object, funcname):
	var callback = funcref(object, funcname)
	if not listeners.has(event):
		listeners[event] = []
	listeners[event].append(callback)

# void remove_listener(object event, object, funcname)
# removes a function reference from the list of listeners for the given named event
func remove_listener(event, object, funcname):
	var callback = funcref(object, funcname)
	if listeners.has(event):
		if listeners[event].find(callback):
			listeners[event].remove(callback)

# void raise_event(object event, object args)
# calls each callback in the list of callbacks in listeners for the given named event, passing args to each
func raise_event(event, args):
	Console.write("Event %s!" % event)
	if listeners.has(event):
		for callback in listeners[event]:
			callback.call_func(args)

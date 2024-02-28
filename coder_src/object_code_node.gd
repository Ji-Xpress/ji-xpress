extends Node
class_name ObjectCodeNode

## Contains reference to the parent object
var object: Node2D = null


# Initialize the object
func _ready():
	SharedState.connect("broadcast", Callable(self, "_on_broadcast"))


# Cleanup routines
func _exit_tree():
	SharedState.disconnect("broadcast", Callable(self, "_on_broadcast"))


## Does a broadcast
func do_broadcast(message_id: String, message):
	SharedState.do_broadcast(message_id, message)


## Handles broadcast messages
func _on_broadcast(message_id: String, message):
	pass

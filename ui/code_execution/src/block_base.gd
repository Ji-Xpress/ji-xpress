extends GraphNode
class_name BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	connect("position_offset_changed", Callable(self, "on_position_offset_changed"))
	connect("close_request", Callable(self, "on_close_request"))
	connect("dragged", Callable(self, "on_dragged"))


## Emitted when the graphnode is moved
func on_position_offset_changed():
	pass # Replace with function body.


## Emitted when the graphnode is closed
func on_close_request():
	pass # Replace with function body.


## Emitted when the graphnode is dragged
func on_dragged(from, to):
	pass # Replace with function body.

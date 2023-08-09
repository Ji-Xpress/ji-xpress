extends GraphNode
class_name BlockBase

# Constants for block types
const block_type_break_loop = "break_loop"
const block_type_broadcast_message = "broadcast_messag"
const block_type_condition = "condition"
const block_type_entry = "entry"
const block_type_function = "function"
const block_type_loop = "loop"
const block_type_move_object = "move_object"
const block_type_rotate_object = "rotate_object"
const block_type_set_global_variable = "set_global_variable"
const block_type_set_object_property = "set_object_property"
const block_type_set_object_variable = "set_object_variable"


## Keeps track of block type
var block_type: String = ""
## Keeps track of block sub type
var block_sub_type: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	connect("position_offset_changed", Callable(self, "on_position_offset_changed"))
	connect("close_request", Callable(self, "on_close_request"))
	connect("dragged", Callable(self, "on_dragged"))


## Gets the metadata of the block
func get_block_metadata():
	return null


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	return false


## Gets the metadata assigned to an input slot
func get_input_slot_metadata(slot_number: int):
	return null


## Gets the metadata assigned to an output slot
func get_output_slot_metadata(slot_number: int):
	return null


## Emitted when the graphnode is moved
func on_position_offset_changed():
	pass # Replace with function body.


## Emitted when the graphnode is closed
func on_close_request():
	pass # Replace with function body.


## Emitted when the graphnode is dragged
func on_dragged(from, to):
	pass # Replace with function body.

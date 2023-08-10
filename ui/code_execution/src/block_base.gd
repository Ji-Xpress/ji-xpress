extends GraphNode
class_name BlockBase

# Constants for block types
const block_type_break_loop: String = "break_loop"
const block_type_broadcast_message: String = "broadcast_messag"
const block_type_condition: String = "condition"
const block_type_entry: String = "entry"
const block_type_function: String = "function"
const block_type_loop: String = "loop"
const block_type_move_object: String = "move_object"
const block_type_rotate_object: String = "rotate_object"
const block_type_set_global_variable: String = "set_global_variable"
const block_type_set_object_property: String = "set_object_property"
const block_type_set_object_variable: String = "set_object_variable"

const condition_true: String = "true"
const condition_false: String = "false"
const condition_finally: String = "finally"

## Keeps track of block type
var block_type: String = ""
## Keeps track of block sub type
var block_sub_type: String = ""
## Keeps track of slot metadata
var input_slots: Dictionary = {}
## Keeps track of slot metadata
var output_slots: Dictionary = {}
## Keeps track of exit slots
var exit_slots: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
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
	if input_slots.has(str(slot_number)):
		return input_slots[str(slot_number)]
	
	return null


## Gets the metadata assigned to an output slot
func get_output_slot_metadata(slot_number: int):
	if output_slots.has(str(slot_number)):
		return output_slots[str(slot_number)]
	
	return null


## Gets the metadata assigned to an exit slot
func get_exit_slot_metadata(slot_number: int):
	if exit_slots.has(str(slot_number)):
		return exit_slots[str(slot_number)]
	
	return null


## Emitted when the graphnode is closed
func on_close_request():
	clear_all_slots()
	queue_free()


## Emitted when the graphnode is dragged
func on_dragged(from, to):
	pass # Replace with function body.

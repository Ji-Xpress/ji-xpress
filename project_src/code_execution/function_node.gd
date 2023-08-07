extends GraphNode

## Contains reference to the code function instance, needed to populate the node
var code_function_instance: ObjectCodeFunction = null


# Called when the node enters the scene tree for the first time.
func _ready():
	populate_controls()


## Populates all child controls
func populate_controls():
	# Populate all parameters
	for instance_key in code_function_instance.block_parameters_metadata:
		var instance: ObjectCustomProperty = code_function_instance.block_parameters_metadata[instance_key]
	
	# Populate all inputs
	for instance_key in code_function_instance.input_parameters_metadata:
		var instance: ObjectCustomProperty = code_function_instance.block_parameters_metadata[instance_key]
	
	# Populate all outputs
	for instance_key in code_function_instance.outputs_metadata:
		var instance: ObjectCustomProperty = code_function_instance.block_parameters_metadata[instance_key]


## Emitted when the graphnode is moved
func _on_position_offset_changed():
	pass # Replace with function body.


## Emitted when the graphnode is closed
func _on_close_request():
	pass # Replace with function body.


## Emitted when the graphnode is dragged
func _on_dragged(from, to):
	pass # Replace with function body.

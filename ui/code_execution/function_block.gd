extends BlockBase

@onready var function_name: Label = $FunctionName

## Contains reference to the code function instance, needed to populate the node
var code_function_instance: ObjectCodeFunction = null


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_function
	block_sub_type = code_function_instance.get(ObjectCodeFunction.prop_function_name)
	function_name.text = block_sub_type
	populate_controls()
	
	super._ready()


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


## Gets the metadata of the block
func get_block_metadata():
	# TODO
	return null


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	# TODO
	return false


## Gets the metadata assigned to an input slot
func get_input_port_metadata(slot_number: int):
	# TODO
	return null


## Gets the metadata assigned to an output slot
func get_output_port_metadata(slot_number: int):
	# TODO
	return null

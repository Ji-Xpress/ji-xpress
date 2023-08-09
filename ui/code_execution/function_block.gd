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

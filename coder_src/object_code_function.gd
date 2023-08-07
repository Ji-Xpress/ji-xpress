extends Resource
class_name ObjectCodeFunction

# Constants
const prop_function_name: String = "function_name"
const prop_function_input_parameters: String = "function_input_parameters"
const prop_function_block_parameters: String = "function_block_parameters"
const prop_function_outputs: String = "function_outputs"

## Name of the function
@export var function_name: String = ""
## Function input parameters
@export var function_input_parameters: Array[ObjectCustomProperty] = []
## Function block parameters
@export var function_block_parameters: Array[ObjectCustomProperty] = []
## Inputs of the function
@export var function_outputs: Array[ObjectCustomProperty] = []


## Stores metadata of all input parameters
var input_parameters_metadata: Dictionary = {}
## Stores metadata of all block parameters
var block_parameters_metadata: Dictionary = {}
## Stores metadata of all outputs
var outputs_metadata: Dictionary = {}

## Array for all input parameters
var all_input_parameters = []
## Array for all block parameters
var all_block_parameters = []
## Array for all outputs
var all_outputs = []


## Initializaion of metadata
func initialize_metadata():
	all_input_parameters = get_all_input_parameters()
	all_block_parameters = get_all_block_parameters()
	all_outputs = get_all_outputs()


## Return the dict template
static func model_template():
	return {
		prop_function_name: "",
		prop_function_input_parameters: [],
		prop_function_block_parameters: [],
		prop_function_outputs: []
	}



## Prepares all metadata for inputs
func get_all_input_parameters():
	var all_parameters: Array[String] = []
	
	for parameter in function_input_parameters:
		var parameter_name: String = parameter[ObjectCustomProperty.prop_prop_name]
		all_parameters.append(parameter)
		input_parameters_metadata[parameter_name] = parameter
	
	return all_parameters


## Prepares all metadata for block parameters
func get_all_block_parameters():
	var all_parameters: Array[String] = []
	
	for parameter in function_block_parameters:
		var parameter_name: String = parameter[ObjectCustomProperty.prop_prop_name]
		all_parameters.append(parameter_name)
		block_parameters_metadata[parameter_name] = parameter
	
	return all_parameters


## Prepares all metadata for outputs
func get_all_outputs():
	var all_outputs: Array[String] = []
	
	for parameter in function_outputs:
		var parameter_name: String = parameter[ObjectCustomProperty.prop_prop_name]
		all_outputs.append(parameter_name)
		outputs_metadata[parameter_name] = parameter
	
	return all_outputs

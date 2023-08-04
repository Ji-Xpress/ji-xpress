extends Resource
class_name ObjectCodeFunction

# Constants
const prop_function_name: String = "function_name"
const prop_function_outputs: String = "function_outputs"
const prop_function_parameters: String = "function_parameters"

## Name of the function
@export var function_name: String = ""
## Inputs of the function
@export var function_outputs: Array[String] = []
## Function parameters
@export var function_parameters: Array[ObjectCustomProperty] = []


## Return the dict template
static func model_template():
	return {
		prop_function_name: "",
		prop_function_outputs: [],
		prop_function_parameters: []
	}

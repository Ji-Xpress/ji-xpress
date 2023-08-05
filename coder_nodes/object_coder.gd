extends Node
class_name ObjectCoder

# Constants
const prop_code_functions: String = "code_functions"
const prop_code_variables: String = "code_variables"
const prop_variable_values: String = "variable_values"

## Metadata of code functions
@export var code_functions: Array[ObjectCodeFunction] = []
## Variables to be used by the coding environment
@export var code_variables: Array[ObjectCustomProperty] = []

## Holder of variable values
var variable_values: Dictionary = {}
## Reference to parent node
var parent_node: Node2D = null


# Initialization
func _ready():
	parent_node = get_parent()


## Prepares dictionary of code variables
func prepare_code_variable_dict(override: bool = false):
	for variable in code_variables:
		var variable_name: String = variable[ObjectCustomProperty.prop_prop_name]
		var variable_value = variable[ObjectCustomProperty.prop_prop_value]
		
		if variable_value.has(variable_name):
			if override:
				set_variable(variable_name, variable_value)
		else:
			set_variable(variable_name, variable_value)


## Gets a variable's value
func get_variable(variable: String):
	if variable_values.has(variable):
		return variable_values[variable]
	
	return null


## Set's a variable value
func set_variable(variable: String, value):
	variable_values[variable] = value


## Executes a function from the parent object
func execute_function(function_name: String, params: Dictionary = {}):
	return parent_node.call(function_name, params)

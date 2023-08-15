extends Node
class_name ObjectCoder

# Constants
const prop_code_functions: String = "code_functions"
const prop_code_variables: String = "code_variables"
const prop_variable_values: String = "variable_values"

## Tracks whether the object is codable or not
@export var can_code: bool = true
## Metadata of code functions
@export var code_functions: Array[ObjectCodeFunction] = []
## Variables to be used by the coding environment
@export var code_variables: Array[ObjectCustomProperty] = []

## Holder of variable values
var variable_values: Dictionary = {}
## Reference to parent node
var parent_node: Node2D = null

## Keeps track of all variable names
var all_variables: Array[String] = []
## Variables metadata
var variable_metadata: Dictionary = {}
## CodeExecutionEngine instance
var code_execution_engine: CodeExecutionEngine = null


# Initialization
func _ready():
	parent_node = get_parent()
	all_variables = get_all_variables()
	
	# Load corresponding script metadata
	var object_index: int = parent_node.get_node(Constants.object_metadata_node).object_index
	var object_name: String = ProjectManager.object_ids[object_index]
	var script_metadata = ProjectManager.open_script(object_name + Constants.scripts_extension)
	
	# Attach the metadata to the code execution engine instance
	if script_metadata != null:
		code_execution_engine = CodeExecutionEngine.new()
		code_execution_engine.initialize_metadata(parent_node, script_metadata)


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


# Gets an array representation of all variables
func get_all_variables():
	var all_variables: Array[String] = []
	
	for variable in code_variables:
		var variable_name: String = variable[ObjectCustomProperty.prop_prop_name]
		all_variables.append(variable_name)
		variable_metadata[variable_name] = variable
		# Also initialize the variable metadata
		variable.initialize_metadata()
	
	return all_variables

extends Node
class_name ObjectCoder

# Constants
const prop_code_functions: String = "code_functions"
const prop_code_variables: String = "code_variables"
const prop_variable_values: String = "variable_values"

## Handles a broadcast
signal broadcast(message_id: String, message: String)

## Tracks whether the object is codable or not
@export var can_code: bool = true
## Metadata of code functions
@export var code_functions: Array[ObjectCodeFunction] = []
## Variables to be used by the coding environment
@export var code_variables: Array[ObjectCustomProperty] = []

## Contains the instance of the code if executed by text code
@onready var object_code_node: ObjectCodeNode = $ObjectCodeNode

## Holder of variable values
var variable_values: Dictionary = {}
## Reference to parent node
var parent_node: Node = null

## Keeps track of all variable names
var all_variables: Array[String] = []
## Variables metadata
var variable_metadata: Dictionary = {}


# Initialization
func _ready():
	parent_node = get_parent()
	all_variables = get_all_variables()
	prepare_code_variable_dict(true)
	SharedState.connect("broadcast", Callable(self, "on_brodcast"))


## Create an initialize a new instance of code execution engine
func code_execution_engine():
	# Load corresponding script metadata
	var object_index: int = parent_node.get_node(Constants.object_metadata_node).project_object_index
	var object_name: String = ProjectManager.object_ids[object_index]
	var script_metadata = null
	
	# Prepare the engine
	var engine: CodeExecutionEngine = CodeExecutionEngine.new()
	engine.object_code_node_instance = object_code_node
	
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		script_metadata = ProjectManager.open_script(object_name + Constants.scripts_extension)
		if script_metadata != null:
			engine.initialize_metadata(parent_node, script_metadata)
	elif ProjectManager.coding_environment == Constants.code_environment_env_code:
		var script: String = ProjectManager.open_code(object_name + Constants.code_extension)
		
		# Prepare object script
		script = "extends ObjectCodeNode\n" + script
		object_code_node.set_script(script)
		object_code_node.object = parent_node
		
		# Prepare function pointers
		for function: ObjectCodeFunction in code_functions:
			object_code_node[function.function_name] = parent_node[function.function_name]
	
	return engine


## Handle a broadcast
func on_brodcast(message_id: String, message: String):
	emit_signal("broadcast", message_id, message)


## Prepares dictionary of code variables
func prepare_code_variable_dict(override: bool = false):
	for variable in code_variables:
		var variable_name: String = variable[ObjectCustomProperty.prop_prop_name]
		var variable_value = variable[ObjectCustomProperty.prop_prop_value]
		var default_value = variable[ObjectCustomProperty.prop_prop_default_value]
		
		if ProjectManager.coding_environment == Constants.code_environment_env_visual:
			if variable_values.has(variable_name):
				if override:
					set_variable(variable_name, default_value)
			else:
				set_variable(variable_name, default_value)
		elif ProjectManager.coding_environment == Constants.code_environment_env_code:
			object_code_node[variable_name] = default_value


## Gets a variable's value
func get_variable(variable: String):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		if variable_values.has(variable):
			return variable_values[variable]
		return null
	elif ProjectManager.coding_environment == Constants.code_environment_env_code:
		return object_code_node.get(variable)


## Set's a variable value
func set_variable(variable: String, value):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		variable_values[variable] = value
	elif ProjectManager.coding_environment == Constants.code_environment_env_code:
		object_code_node[variable] = value


## Executes a function from the parent object
func execute_function(function_name: String, params: Dictionary = {}):
	return parent_node.call(function_name, params)


# Gets an array representation of all variables
func get_all_variables():
	var all_variables: Array[String] = []
	
	# Prepare metadata and values
	for variable in code_variables:
		var variable_name: String = variable[ObjectCustomProperty.prop_prop_name]
		all_variables.append(variable_name)
		variable_metadata[variable_name] = variable
	
	return all_variables

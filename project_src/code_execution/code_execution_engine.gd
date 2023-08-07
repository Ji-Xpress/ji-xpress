extends Node
class_name CodeExecutionEngine

const prop_entry_blocks: String = "entry_blocks"
const prop_code_blocks: String = "code_blocks"

## Contains reference to the object it is attached to
var object_id: String = ""
## Contains metadata of all nodes that need to be executed
var node_execution_metadata: Dictionary = {}
## Contains the values of execution for each node
## Format: {node_id}_{output_variable}
var node_outputs_metadata: Dictionary = {}
## Data loaed from code file
var block_execution_data: Dictionary = {}
## References the code file name
var code_file_name: String = ""


static func model_template():
	return {
		# Contains references to entry blocks
		prop_entry_blocks: {},
		# Contains references to other code blocks
		prop_code_blocks: {},
	}


## Loads code from a file
func load_code_file(open_code_file_name: String = ""):
	if open_code_file_name == "":
		return false
	
	code_file_name = open_code_file_name
	return true
	

## Saves the code execution data to file
func save_code_file(save_code_file_name: String = ""):
	var file_name = save_code_file_name
	
	if save_code_file_name == "":
		file_name = code_file_name
	
	if file_name == "":
		return false


## Executes code from entry blocks
func execute_code_from_entrypoint(node_id: String):
	pass


## Sets the output value of every node's output
func set_node_output_value(node_id: String, output_id: String, value):
	node_outputs_metadata[node_id + "_" + output_id] = value


## Gets the output value of a specific output node
func get_node_output_value(node_id: String, output_id: String):
	var metadata_key: String = node_id + "_" + output_id
	
	if node_outputs_metadata.has(metadata_key):
		return node_outputs_metadata[metadata_key]
	
	return null

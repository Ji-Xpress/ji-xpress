extends Node
class_name CodeExecutionEngine

const prop_object_index: String = "object_index"
const prop_entry_blocks: String = "entry_blocks"
const prop_code_blocks: String = "code_blocks"
const prop_connections: String = "connections"
const prop_input_port_metadata: String = "input_port_metadata"
const prop_exit_port_metadata: String = "exit_port_metadata"
const prop_exit_port_result_metadata: String = "exit_port_result_metadata"
const prop_connection_from_metadata: String = "connection_from_metadata"
const prop_connection_to_metadata: String = "connection_to_metadata"
const prop_block_execution_result: String = "block_execution_result"
const prop_block_execution_value: String = "block_execution_value"

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
## Keeps track of branching steps and executes the finally block once we backtrack
var block_branching_steps: Array[String] = []


## Model for persistance
static func model_template():
	return {
		# Index of the object it references
		prop_object_index: -1,
		# Contains references to entry blocks
		prop_entry_blocks: {},
		# Contains references to other code blocks
		prop_code_blocks: {},
		# Metadata for input ports
		prop_input_port_metadata: {},
		# Metadata for exit ports
		prop_exit_port_metadata: {},
		# Metadata for exit port results
		prop_exit_port_result_metadata: {},
		# Stores all the connections
		prop_connections: []
	}


## Model for execution
static func execution_result_model_template(result: String = "", value = null):
	return {
		# Result (if any) of the execution (for routing)
		prop_block_execution_result: result,
		# Value of the execution (for value tracking)
		prop_block_execution_value: value
	}


## Executes code from entry blocks
func execute_code_from_entrypoint(block_name: String):
	# TODO: Start executing
	pass


## Sets the output value of every node's output
func set_block_exit_result(block_name: String, exit_port: int, result: String, value):
	node_outputs_metadata[block_name + "_" + str(exit_port)] = execution_result_model_template(result, value)


## Gets the output value of a specific output node
func get_block_output(block_name: String, exit_port: String):
	var metadata_key: String = block_name + "_" + exit_port
	
	if node_outputs_metadata.has(metadata_key):
		return node_outputs_metadata[metadata_key]
	
	return null

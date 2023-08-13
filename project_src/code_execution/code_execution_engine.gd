extends Node
class_name CodeExecutionEngine

const prop_object_index: String = "object_index"
const prop_entry_blocks: String = "entry_blocks"
const prop_code_blocks: String = "code_blocks"
const prop_connections: String = "connections"
const prop_input_port_metadata: String = "input_port_metadata"
const prop_exit_port_metadata: String = "exit_port_metadata"
const prop_exit_port_result_metadata: String = "exit_port_result_metadata"
const prop_results_branching_metadata: String = "results_branching_metadata"
const prop_connection_from_metadata: String = "connection_from_metadata"
const prop_connection_to_metadata: String = "connection_to_metadata"
const prop_block_execution_result: String = "block_execution_result"
const prop_block_execution_value: String = "block_execution_value"
const prop_incoming_connections: String = "incoming_connections"
const prop_outgoing_connections: String = "outgoing_connections"
const prop_port: String = "port"
const prop_block: String = "block"

## Contains reference to the object it is attached to
var object_id: String = ""
## Contains metadata of all nodes that need to be executed
var node_execution_metadata: Dictionary = {}
## Contains the values of execution for each node
## Format: {node_id}_{output_variable}
var node_outputs_metadata: Dictionary = {}
## Data loaed from code file
var block_execution_data: Dictionary = {}
## Contains metadata on how blocks are connected
var block_connection_metadata: Dictionary = {}
## References the code file name
var code_file_name: String = ""
## Keeps track of branching steps and executes the finally block once we backtrack
var block_branching_steps: Array[String] = []
## Keeps track of the current executing block
var current_execution_block = null


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
		# Metadata on result branching
		prop_results_branching_metadata: {},
		# Stores all the connections
		prop_connections: []
	}


## Prepares data for each block on its connections
static func block_connection_metdata_template():
	return {
		prop_incoming_connections: {},
		prop_outgoing_connections: {}
	}


## Model for execution
static func execution_result_model_template(result: String = "", value = null):
	return {
		# Result (if any) of the execution (for routing)
		prop_block_execution_result: result,
		# Value of the execution (for value tracking)
		prop_block_execution_value: value
	}


# Initializes internal metadata derived from a JSON file
func initialize_metadata(metadata: Dictionary):
	node_execution_metadata = metadata
	
	for connection in metadata[prop_connections]:
		var block_from: String = connection.from
		var block_to: String = connection.to
		var port_from: int = connection.from_port
		var port_to: int = connection.to_port
		
		# Create metadata templates for for from and to blocks if they do not exist
		if not block_connection_metadata.has(block_from):
			block_connection_metadata[block_from] = block_connection_metdata_template()
		
		if not block_connection_metadata.has(block_to):
			block_connection_metadata[block_to] = block_connection_metdata_template()
		
		# Prepare data for outgoing connections
		if not block_connection_metadata[block_from][prop_outgoing_connections].has(str(port_from)):
			block_connection_metadata[block_from][prop_outgoing_connections][str(port_from)] = []
		
		block_connection_metadata[block_from][prop_outgoing_connections][str(port_from)].append({
			prop_block: block_to,
			prop_port: port_to
		})
		
		# Prepare data for incoming connections
		if not block_connection_metadata[block_to][prop_incoming_connections].has(str(port_to)):
			block_connection_metadata[block_to][prop_incoming_connections][str(port_to)] = []
		
		block_connection_metadata[block_to][prop_incoming_connections][str(port_to)].append({
			prop_block: block_from,
			prop_port: port_from
		})


## Executes code from entry blocks
func execute_code_from_entrypoint(block_name: String):
	# TODO: Start executing
	if node_execution_metadata[prop_entry_blocks].has(block_name):
		current_execution_block = node_execution_metadata[prop_entry_blocks][block_name]
		execute_current_block(true)
	else:
		current_execution_block = null
		return false


## Executes a single block
func execute_current_block(recursive_execution: bool = true):
	pass


## Sets the output value of every node's output
func set_block_exit_port_result(block_name: String, exit_port: int, result: String, value):
	node_outputs_metadata[block_name + "_" + str(exit_port)] = execution_result_model_template(result, value)


## Gets the output value of a specific output node
func get_block_exit_port_result(block_name: String, exit_port: String):
	var metadata_key: String = block_name + "_" + exit_port
	
	if node_outputs_metadata.has(metadata_key):
		return node_outputs_metadata[metadata_key]
	
	return null


## Sets the metadata for a block's execution
func set_block_execution_metadata(block_name: String, result: String, value):
	block_execution_data[block_name] = execution_result_model_template(result, value)


## Gets the metadata for a block's execution
func get_block_execution_metadata(block_name: String):
	if block_execution_data.has(block_name):
		return block_execution_data[block_name]
	
	return null

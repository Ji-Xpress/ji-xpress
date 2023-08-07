extends Node
class_name CodeExecutionEngine

## Contains metadata of all nodes that need to be executed
var node_metadata: Dictionary = {}
## Contains the values of execution for each node
## Format: {node_id}_{output_variable}
var node_outputs_metadata: Dictionary = {}


## Runs the code from the designated entrypoint
func run_entrypoint(node_id: String):
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

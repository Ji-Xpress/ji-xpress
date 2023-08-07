extends Object
class_name BlockExecutionMetadata

const prop_block_id: String = "block_id"
const prop_block_type: String = "block_type"
const prop_block_sub_type: String = "block_sub_type"
const prop_input_parameters: String = "input_parameters"
const prop_block_parameters: String = "block_parameters"
const prop_exit_nodes: String = "exit_nodes"
const prop_output_nodes: String = "output_nodes"
const prop_has_been_executed: String = "has_been_executed"

var block_id: String = ""
var block_type: String = ""
var block_sub_type: String = ""
var input_parameters: Dictionary = {}
var block_parameters: Dictionary = {}
var exit_nodes: Dictionary = {}
var output_nodes: Dictionary = {}
var has_been_executed: bool = false

static func model_template():
	return {
		# Block canvas ID
		prop_block_id: "",
		# Block type
		prop_block_type: "",
		# Block sub type
		prop_block_sub_type: "",
		# Keeps track of all input parameter block connections
		prop_input_parameters: {},
		# Keeps track of all block parameter values
		prop_block_parameters: {},
		# Keeps track of connections made by the exit nodes
		prop_exit_nodes: {},
		# Keeps track of connections made by the output nodes
		prop_output_nodes: {},
	}

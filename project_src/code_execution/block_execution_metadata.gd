extends Object
class_name BlockExecutionMetadata

const prop_block_id: String = "block_id"
const prop_block_type: String = "block_type"
const prop_block_sub_type: String = "block_sub_type"
const prop_input_parameters: String = "input_parameters"
const prop_block_parameters: String = "block_parameters"
const prop_exit_port_results: String = "exit_port_results"
const prop_has_been_executed: String = "has_been_executed"
const prop_position_offset_x: String = "position_offset_x"
const prop_position_offset_y: String = "position_offset_y"

# Input parameters
const prop_input_param_source_block_id: String  = "input_source_block_id"
const prop_input_param_source_block_param_id: String  = "input_source_block_parameter_id"

# Block parameters
const prop_block_parameter_value: String = "block_parameter_value"

var block_id: String = ""
var block_type: String = ""
var block_sub_type: String = ""
var input_parameters: Dictionary = {}
var block_parameters: Dictionary = {}
var exit_nodes: Dictionary = {}
var output_nodes: Dictionary = {}
var has_been_executed: bool = false


## Template for a model we can save
static func model_template():
	return {
		# Block canvas ID
		prop_block_id: "",
		# X Position on GraphEdit
		prop_position_offset_x: 0,
		# Y Position on GraphEdit
		prop_position_offset_y: 0,
		# Block type
		prop_block_type: "",
		# Block sub type
		prop_block_sub_type: "",
		# Keeps track of all input parameter block connections
		prop_input_parameters: {},
		# Keeps track of all block parameter values
		prop_block_parameters: {},
		# Keeps track of results delivered by exit ports
		prop_exit_port_results: {}
	}


## Template for an input parameter dictionary entry
static func input_parameter_template():
	return {
		prop_input_param_source_block_id: "",
		prop_input_param_source_block_param_id: ""
	}


## Template for a block parameter dictionary entry
static func block_parameter_template():
	return {
		prop_block_parameter_value: ""
	}

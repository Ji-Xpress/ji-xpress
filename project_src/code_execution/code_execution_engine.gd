extends Node
class_name CodeExecutionEngine

const prop_object_index: String = "object_index"
const prop_entry_blocks: String = "entry_blocks"
const prop_code_blocks: String = "code_blocks"
const prop_connections: String = "connections"
const prop_connection_from_metadata: String = "connection_from_metadata"
const prop_connection_to_metadata: String = "connection_to_metadata"
const prop_block_execution_result: String = "block_execution_result"
const prop_block_execution_value: String = "block_execution_value"
const prop_incoming_connections: String = "incoming_connections"
const prop_outgoing_connections: String = "outgoing_connections"
const prop_last_block_index: String = "last_block_index"
const prop_port: String = "port"
const prop_block: String = "block"
const prop_recomputes: String = "recomputes"

## Contains metadata of all nodes that need to be executed
var node_execution_metadata: Dictionary = {}
## Contains the values of execution for each node
## Format: {node_id}_{output_variable}
var node_outputs_metadata: Dictionary = {}
## Data loaed from code file
var block_execution_data: Dictionary = {}
## Contains metadata on how blocks are connected
var block_connection_metadata: Dictionary = {}
## Stores metadata condusive for execution of entrypoints
var entrypoint_block_metadata: Dictionary = {}
## References the code file name
var code_file_name: String = ""
## Keeps track of branching steps and executes the finally block once we backtrack
var block_branching_steps: Array[Dictionary] = []
## Keeps track of breaking steps and executes the finally block once we backtrack
var block_breaking_steps: Array[Dictionary] = []
## Keeps track of the current executing block
var current_execution_block = null
## Keeps track of the game object instance
var game_object_instance: Node = null
## Contains a reference to the object code node if executed as textual code
var object_code_node_instance = null
## Instance of Experession Engine
var expression_engine: ExpressionEngine = null
## Current instance of the finally block data
var current_finally_block_data: Dictionary = {}


## Model for persistance
static func model_template():
	return {
		# Keeps track of the last block index
		prop_last_block_index: 0,
		# Index of the object it references
		prop_object_index: -1,
		# Contains references to entry blocks
		prop_entry_blocks: {},
		# Contains references to other code blocks
		prop_code_blocks: {},
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
func initialize_metadata(object_instance: Node, metadata: Dictionary):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		# Initialize variables that build the code execution engine's base
		game_object_instance = object_instance
		node_execution_metadata = metadata
		expression_engine = ExpressionEngine.new()
		expression_engine.game_object_instance = game_object_instance
		expression_engine.initialize_engine()
		
		# Build entrypoint metadata entries
		entrypoint_block_metadata = {}
		
		for entrypoint_block in metadata[prop_entry_blocks]:
			var metadata_item = metadata[prop_entry_blocks][entrypoint_block]
			var block_id: String = metadata_item.block_id
			var block_sub_type: String = metadata_item.block_sub_type
			
			if not entrypoint_block_metadata.has(block_sub_type):
				entrypoint_block_metadata[block_sub_type] = []
			
			entrypoint_block_metadata[block_sub_type].append(block_id)
		
		# Build metadata on connections on each block
		for connection in metadata[prop_connections]:
			var block_from: String = connection.from_node
			var block_to: String = connection.to_node
			var port_from: int = connection.from_port
			var port_to: int = connection.to_port
			var port_from_metadata = connection[prop_connection_from_metadata]
			var port_to_metadata = connection[prop_connection_to_metadata]
			
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
				prop_port: port_to,
				prop_connection_from_metadata: port_from_metadata,
				prop_connection_to_metadata: port_to_metadata
			})
			
			# Prepare data for incoming connections
			if not block_connection_metadata[block_to][prop_incoming_connections].has(str(port_to)):
				block_connection_metadata[block_to][prop_incoming_connections][str(port_to)] = []
			
			block_connection_metadata[block_to][prop_incoming_connections][str(port_to)].append({
				prop_block: block_from,
				prop_port: port_from,
				prop_connection_from_metadata: port_from_metadata,
				prop_connection_to_metadata: port_to_metadata
			})


## Executes code from an entrypoint type
func execute_from_entrypoint_type(entrypoint_type: String):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		if entrypoint_block_metadata.has(entrypoint_type):
			expression_engine.current_condition_type = "entry_" + entrypoint_type
			
			for entrypoint_block in entrypoint_block_metadata[entrypoint_type]:
				execute_code_from_entrypoint(entrypoint_block)
			
			expression_engine.current_condition_type = ""
			return true
	elif ProjectManager.coding_environment == Constants.code_environment_env_code:
		var method_name: String = "_on_" + entrypoint_type
		if object_code_node_instance != null:
			if object_code_node_instance.has_method(method_name):
				object_code_node_instance.call(method_name)
	
	return false


## Executes code from entry blocks
func execute_code_from_entrypoint(block_name: String):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual:
		if node_execution_metadata[prop_entry_blocks].has(block_name):
			# Clear all branching steps
			block_branching_steps = []
			# Start execution
			current_execution_block = node_execution_metadata[prop_entry_blocks][block_name]
			execute_current_block(true)
		else:
			current_execution_block = null
			return false
	elif ProjectManager.coding_environment == Constants.code_environment_env_code:
		var method_name: String = "_on_" + block_name
		if object_code_node_instance.has_method(method_name):
			object_code_node_instance.call(method_name)


## Executes a single block
func execute_current_block(recursive_execution: bool = true, execute_finally: bool = false, override_recompute: bool = false):
	if ProjectManager.coding_environment == Constants.code_environment_env_visual and current_execution_block != null:
		var block_type: String = current_execution_block[BlockExecutionMetadata.prop_block_type]
		var block_instance: BlockTypeExecutionBase = load("res://project_src/code_execution/block_types/" + block_type + ".gd").new()
		# Set the block sub type
		block_instance.sub_type = current_execution_block[BlockExecutionMetadata.prop_block_sub_type]
		# Assign the expression engine to the block
		block_instance.expression_engine = expression_engine
		
		# Extract metadata
		var block_name: String = current_execution_block[BlockExecutionMetadata.prop_block_id]
		# Tracks recomputing
		var recomputes: bool = false
		
		# Compute result and get the exit port
		if current_finally_block_data.has(prop_recomputes):
			recomputes = current_finally_block_data[prop_recomputes]
		
		if (not execute_finally) or (recomputes and not override_recompute):
			# Invalidate the current finally block data
			current_finally_block_data = {}
			
			# Execute based on computational results
			block_instance.initialize(game_object_instance, \
				current_execution_block[BlockExecutionMetadata.prop_input_parameters], \
				current_execution_block[BlockExecutionMetadata.prop_block_parameters],
				block_instance.sub_type)
		
			# Check to see if there is a finally block
			var block_results = current_execution_block[BlockExecutionMetadata.prop_results_branching_metadata]
			var contains_finally: bool = block_results[BlockBase.prop_contains_finally]
			
			# Compute result
			var result = await block_instance.compute_result()
			var is_recomputing: bool = block_instance.is_recomputing()
			var reverts_to_finally: bool = block_instance.is_reverting_to_finally()
			var is_breakable: bool = block_instance.is_breakable()
			var reverts_to_break: bool = block_instance.is_reverting_to_break()
			
			# If it reverts back to a finally block and also breaks execution of the last breakable block
			if reverts_to_finally and reverts_to_break:
				# Remove all other finally blocks after the forced break
				if block_branching_steps.size() > 0 and block_breaking_steps.size() > 0:
					while block_branching_steps[block_branching_steps.size() - 1][prop_block] != block_breaking_steps[block_breaking_steps.size() - 1][prop_block]:
						block_branching_steps.pop_back()
				
				force_last_finally_execution(recursive_execution, true)
				return true
			elif reverts_to_finally:
				# Only needs to revert to finally for now
				force_last_finally_execution(recursive_execution, true)
				return true
			
			# Check that result has exit port
			var result_has_exit_port: bool = current_execution_block[BlockExecutionMetadata.prop_exit_port_result_metadata].has(str(result))
			
			# Validate that we did not have a problem in execution
			if result != null and (result_has_exit_port or execute_finally):
				# For a recomputing block we execute finally only if its execution result resolves to false
				if execute_finally and str(result) != "true":
					# Execute finally and exit the function
					execute_finally_block(block_name, recursive_execution)
					return true
				
				# Else proceed as is
				var exit_port: int = current_execution_block[BlockExecutionMetadata.prop_exit_port_result_metadata][str(result)]
				var value = block_instance.get_computed_value()
				# Set metadata for block execution
				set_block_exit_port_result(block_name, exit_port, str(result), value)
				set_block_execution_metadata(block_name, str(result), value)
				
				# Track the block if it contains a finally
				if contains_finally:
					block_branching_steps.append({
						prop_block: block_name,
						prop_recomputes: is_recomputing
					})
				
				if is_breakable:
					block_breaking_steps.append({
						prop_block: block_name,
						prop_recomputes: is_recomputing
					})
				
				if recursive_execution:
					if block_connection_metadata.has(block_name):
						if block_connection_metadata[block_name][prop_outgoing_connections].has(str(exit_port)):
							for block in block_connection_metadata[block_name][prop_outgoing_connections][str(exit_port)]:
								current_execution_block = node_execution_metadata[prop_code_blocks][block[prop_block]]
								execute_current_block()
						else:
							if block_branching_steps.size() > 0:
								force_last_finally_execution(recursive_execution)
				
					return true
		else:
			# Execute only the finally block
			execute_finally_block(block_name, recursive_execution)
			return true
		
		return false


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


## Forces the execution of the last finally block
func force_last_finally_execution(recursive_execution: bool, override_recompute: bool = false):
	if block_branching_steps.size() > 0:
		current_finally_block_data = block_branching_steps.pop_back()
		var current_block_name: String = current_finally_block_data[prop_block]
		current_execution_block = node_execution_metadata[prop_code_blocks][current_block_name]
		execute_current_block(recursive_execution, true, override_recompute)


## Only does execution for the finally block
func execute_finally_block(block_name: String, recursive_execution, execute_finally = false):
	var exit_port: int = current_execution_block[BlockExecutionMetadata.prop_exit_port_result_metadata][BlockBase.condition_finally]
	if block_connection_metadata[block_name][prop_outgoing_connections].has(str(exit_port)):
		for block in block_connection_metadata[block_name][prop_outgoing_connections][str(exit_port)]:
			var current_block_name: String = block[prop_block]
			current_execution_block = node_execution_metadata[prop_code_blocks][current_block_name]
			execute_current_block(recursive_execution, execute_finally)

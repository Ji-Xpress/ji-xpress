## Editing environment

The code editing environment makes of the the Godot `GraphEdit` node, which introduces various `GraphNode` children. Ji-Xpress has customized the base Node in the `res://ui/code_execution/src/block_base.gd` file containing shared logic for each custom `GraphNode`. The class name is called `BlockBase`. It implements the following shared functions:

```gdscript
## Gets the metadata of the block
func get_block_metadata()

## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary)

## Gets the metadata assigned to an input slot
func get_input_port_metadata(port_number: int = -1)

## Gets the metadata assigned to an exit slot
func get_exit_port_metadata(port_number: int = -1)

## Returns all exit slots with results
func get_exit_ports_with_results(condition: String = "")

## Returns the results of branching
func get_results_branching_metadata()
```

The `res://ui/code_execution/` folder contains the various different derived block types.

The example below demonstrates how the `condition_block` implements its metadata:

```gdscript
extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_condition
	super._ready()
	
	# Slot metadata
	input_ports = {
		"0": condition_true
	}
	exit_ports = {
		"0": condition_true,
		"1": condition_false,
		"2": condition_finally
	}
	exit_ports_with_results = {
		condition_true: 0,
		condition_false: 1,
		condition_finally: 2
	}
	
	contains_true = true
	contains_false = true
	contains_finally = true


## Gets the metadata of the block
func get_block_metadata():
	return {
		"condition": $Condition.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$Condition.text = metadata.condition
```

## Saving and Loading script files

This is done in the `GraphEdit` at `res://ui/code_canvas/graph_edit.tscn`.

```gdscript
# Saves the script
func save_script()

## Loads the script from the script file
func load_script()
```

This creates a persistent script model that saves and loads GraphNode data into a JSON data model that can be used for code execution purposes. The model template for the JSON data model is found in `res://project_src/code_execution/code_execution_engine.gd` (`CodeExecutionEngine`) under the function `model_template()`:

```gdscript
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
```

* `last_block_index` contains the last index of the block that is persisted so that new blocks can be sequentially named.
* `object_index` stores the index of the object as per `ProjectManager` game object index.
* `entry_blocks` are blocks that are used as entry points to start executing the code.
* `code_blocks` are code blocks that are used to store normal blocks that are not entry blocks.
* `connections` store the connections between the nodes.

Each block derives its data model from `res://project_src/code_execution/block_execution_metadata.gd` (`BlockExecutionMetadata`) under the function `model_template()`. It persists data from the GraphNode according to values stored in its configuration in the code file.

```gdscript
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
	# Metadata for input ports
	prop_input_port_metadata: {},
	# Input port metadata
	prop_exit_port_metadata: {},
	# Exit port results metadata
	prop_exit_port_result_metadata: {},
	# Branching metadata
	prop_results_branching_metadata: {}
}
```

## Code Execution

* The `CodeExecutionEngine` (`res://project_src/code_execution/code_execution_engine.gd`) is also responsible for executing the various code blocks.
* It makes use of the various `block_types` in the `res://project_src/code_execution/block_types/` folder, which has blocks inheriting `BlockTypeExecutionBase` (`res://project_src/code_execution/block_type_execution_base.gd`) for their code execution model. The blocks implement the following functions:

```gdscript
extends Object

var block_parameters = {}
var input_parameters = {}

class_name BlockTypeExecutionBase
## Contains a reference to the game object instance
var game_object_instance: Node2D = null
## Instance of the expression evaluation engine
var expression_engine: ExpressionEngine = null
## Stores the computed value (if any)
var computed_value = null
## Keeps track of types
var type: String = ""
## Keeps track of sub types
var sub_type: String = ""


## Initialization
func initialize(object_instance, input_params, block_params, block_sub_type = "")

## Computes the result of the block's execution
func compute_result()

## Gets the computed value if computed
func get_computed_value()

## Checks to see if the block reverts back to a finally
func is_reverting_to_finally()

## Checks to see if it revers back to a break
func is_reverting_to_break()

## Checks to see if it is breakable
func is_breakable()

## Checks to see if the block recomputes before reverting to finally
func is_recomputing()
```

* The `CodeExecutionEngine` also makes use of `ExpressionEngine` - which it passes to each `BlockTypeExecutionBase` derived object for purposes of evaluating expressions passed in as parameters. The following is a rundown of some of the vital functions in it:

* `initialize_metadata` - Initializes execution metdata for an object. Creates metadata that also maps the various block connections allowing it to execute blocks sequentially.
* `execute_from_entrypoint_type` - Allows code to be executed from a specific entrypoint type (for instance `ready`).
* `execute_code_from_entrypoint` - Executes code from and entry block's block name.
* `execute_current_block` - Executes metadata assigned to `current_execution_block`.
* `force_last_finally_execution` - Force executes the 1st block backtracked with a valid `finally` connection from the `current_execution_block`.
* `execute_finally_block` - Used to specifically execute a `finally` block for a specific `block_name`.

### How `execute_current_block` functions

The execution model takes into consideration the following important parameters:

* `execute_finally` - if we need to execute the `finally` block for the `current_execution_block`.
* `recomputes` - if that block needs to recompute before it moves on to `finally`. If the result of execution is true it executes the `true` connected block, otherwise executes `finally`. This is ideal for loops.
* `override_recompute` - we force the execution of `finally` regardless of `recomputes` flag.

Within the scope of the current block's execution results:

* `reverts_to_finally` - marks that it has a finally port.
* `reverts_to_break` - marks that it needs to break the last breakable block. This for instance is the case when we need to break the execution of a loop.
* Important to note: `reverts_to_break` overrides `reverts_to_finally` by backtracking all the blocks that have a `finally` port connection. And executes the `finally` that is in the last block with the `reverts_to_break` flag. Meaning it will ignore all other `reverts_to_finally` blocks coming after the `reverts_to_break` block.

### How game objects load visual code blocks

* The `ObjectCoder` node has the `code_execution_engine()` function, which creates an instance of `CodeExecutionEngine`.
* Below is an example of how the `_ready()` function implements this:

```gdscript
var code_execution_engine = object_coder.code_execution_engine()
code_execution_engine.execute_from_entrypoint_type("ready")
```

* The `code_execution_engine()` function by default loads the current execution engine attached to the object, as so:

```gdscript
func code_execution_engine():
	# Load corresponding script metadata
	var object_index: int = parent_node.get_node(Constants.object_metadata_node).project_object_index
	var object_name: String = ProjectManager.object_ids[object_index]
	var engine: CodeExecutionEngine = CodeExecutionEngine.new()
	var script_metadata = ProjectManager.open_script(object_name + Constants.scripts_extension)
	
	if script_metadata != null:
		engine.initialize_metadata(parent_node, script_metadata)
	
	return engine
```

## The Expression Engine

* The `ExpressionEngine` (`res://project_src/code_execution/expression_engine.gd`) computes expressions using the `compute_expression` function. The function accepts a single `String` parameter with the evaluation it needs to execute.
* Important to note: the `current_condition_type` is used to add extra dictionary parameters used for only specific types of conditional computations. This is how it works:

```gdscript
## Evaluates an expression and sends back the results
func compute_expression(expression: String):
	var var_names = []
	var var_values = []
	
	# Build variable sets for the expression
	if current_condition_type != "":
		var condition_variable = SharedState.expression_variables.get(current_condition_type)
		if condition_variable != null:
			for variable in condition_variable:
				var_names.append(variable)
				var_values.append(SharedState.expression_variables[current_condition_type][variable])
	
	# Variables and properties
	var_names.append("variables")
	var_values.append(game_object_instance.object_coder.variable_values)
	var_names.append("globals")
	var_values.append(SharedState.state_variables)
	var_names.append("properties")
	var_values.append(game_object_instance.object_metadata.prop_values)
	
	# Object state
	var_names.append("pos_x")
	var_values.append(game_object_instance.position.x)
	var_names.append("pos_y")
	var_values.append(game_object_instance.position.y)
	var_names.append("rotation")
	var_values.append(game_object_instance.rotation_degrees)
	
	# Evaluate expression and return results
	return evaluate(expression, var_names, var_values)
```

* Note that the extra variable keys are extracted from `SharedState.expression_variables` dictionary entry, where each individual key represents a variable that can be used in the expression. These can even be initialized in the story pack's load / initialization logic.
* Example of use in the `entry` block logic:

```gdscript
## Computes the result of the block's execution
func compute_result():
	# Set the expression engine condition type for more refined variable evaluations
	expression_engine.current_condition_type = "entry_" + sub_type
	# Evaluate
	computed_value = expression_engine.compute_expression(block_parameters.condition)
	# Clear the expression engine condition type
	expression_engine.current_condition_type = ""
	
	return computed_value
```

* This is also the case in the custom function evaluation block as so:

```gdscript
## Computes the result of the block's execution
func compute_result():
	# Set the expression engine condition type for more refined variable evaluations
	expression_engine.current_condition_type = "function_" + sub_type
	var condition_result = game_object_instance.call(sub_type, block_parameters)
	return condition_result
	# Clear the expression engine condition type
	expression_engine.current_condition_type = ""
```
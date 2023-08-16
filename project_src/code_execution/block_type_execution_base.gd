extends Object
class_name BlockTypeExecutionBase

var block_parameters = {}
var input_parameters = {}

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
func initialize(object_instance, input_params, block_params, block_sub_type = ""):
	game_object_instance = object_instance
	input_parameters = input_params
	block_parameters = block_params
	sub_type = block_sub_type


## Computes the result of the block's execution
func compute_result():
	pass


## Gets the computed value if computed
func get_computed_value():
	return computed_value


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false


## Checks to see if the block recomputes before reverting to finally
func is_recomputing():
	return false

extends Object
class_name BlockTypeExecutionBase

var block_parameters = {}
var input_parameters = {}

## Contains a reference to the game object instance
var game_object_instance: Node2D = null


## Initialization
func initialize(object_instance, input_params, block_params):
	game_object_instance = object_instance
	input_parameters = input_params
	block_parameters = block_params


## Computes which exit route it is meant to take
func compute_exit_block():
	pass


## Computes the result of the block's execution
func compute_result():
	pass


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	pass

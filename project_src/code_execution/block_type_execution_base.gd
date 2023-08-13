extends Object
class_name BlockTypeExecutionBase

var block_parameters = {}
var input_parameters = {}


## Computes which exit route it is meant to take
func compute_exit_block():
	pass


## Computes the result of the block's execution
func compute_result():
	pass


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	pass

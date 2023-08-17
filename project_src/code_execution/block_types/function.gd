extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	var condition_result = game_object_instance.call(sub_type, block_parameters)
	return condition_result


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

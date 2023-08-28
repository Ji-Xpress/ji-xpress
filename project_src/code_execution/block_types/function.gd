extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Set the expression engine condition type for more refined variable evaluations
	expression_engine.current_condition_type = "function_" + sub_type
	var condition_result = game_object_instance.call(sub_type, block_parameters)
	# Clear the expression engine condition type
	expression_engine.current_condition_type = ""
	
	return condition_result


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

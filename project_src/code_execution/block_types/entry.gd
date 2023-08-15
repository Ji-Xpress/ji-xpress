extends BlockTypeExecutionBase

var condition_result: bool = false


## Computes the block's result
func compute_exit_block():
	return condition_result


## Computes the result of the block's execution
func compute_result():
	# Set the expression engine condition type for more refined variable evaluations
	expression_engine.current_condition_type = "entry_" + sub_type
	# Evaluate
	var condition_result = bool(expression_engine.compute_expression(block_parameters.condition))
	# Clear the expression engine condition type
	expression_engine.current_condition_type = ""
	
	return condition_result


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

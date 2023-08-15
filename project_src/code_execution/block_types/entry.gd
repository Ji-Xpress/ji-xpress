extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Set the expression engine condition type for more refined variable evaluations
	expression_engine.current_condition_type = "entry_" + sub_type
	# Evaluate
	computed_value = expression_engine.compute_expression(block_parameters.condition)
	# Clear the expression engine condition type
	expression_engine.current_condition_type = ""
	
	return computed_value


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

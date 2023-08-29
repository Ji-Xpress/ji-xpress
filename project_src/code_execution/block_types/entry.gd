extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Evaluate
	computed_value = str(expression_engine.compute_expression(block_parameters.condition)) == "true"
	return computed_value


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

extends BlockTypeExecutionBase


## Computes which exit route it is meant to take
func compute_result():
	var condition_result = str(expression_engine.compute_expression(block_parameters.condition)) == "true"
	return condition_result


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

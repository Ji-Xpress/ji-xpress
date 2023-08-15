extends BlockTypeExecutionBase


## Computes which exit route it is meant to take
func compute_exit_block():
	var condition_result = bool(expression_engine.compute_expression(block_parameters.condition))
	return condition_result


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	computed_value = bool(expression_engine.compute_expression(block_parameters.condition))
	return computed_value


## Checks to see if the block recomputes before reverting to finally
func is_recomputing():
	return true


## Block is breakable
func is_breakable():
	return true

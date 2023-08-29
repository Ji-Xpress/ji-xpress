extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	computed_value = str(expression_engine.compute_expression(block_parameters.condition)) == "true"
	
	if computed_value:
		return true
	else:
		return result_finally


## Checks to see if the block recomputes before reverting to finally
func is_recomputing():
	return true


## Block is breakable
func is_breakable():
	return true

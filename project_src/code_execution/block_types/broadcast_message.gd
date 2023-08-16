extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	var computed_message = expression_engine.compute_expression(block_parameters.message)
	SharedState.do_broadcast(block_parameters.message_id, computed_message)
	return true

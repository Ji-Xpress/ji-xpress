extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Compute the message
	var computed_message = expression_engine.compute_expression(block_parameters.message)
	
	# Place broadcast in shared state for any broadcast entry block
	if not SharedState.expression_variables.has("entry_broadcast"):
		SharedState.expression_variables["entry_broadcast"] = {}
	
	SharedState.expression_variables["entry_broadcast"]["broadcast_message"] = {
		"message_id": block_parameters.message_id,
		"message": computed_message
	}
	
	SharedState.do_broadcast(block_parameters.message_id, computed_message)
	return true

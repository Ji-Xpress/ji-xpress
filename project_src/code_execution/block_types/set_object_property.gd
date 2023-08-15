extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	game_object_instance.object_metadata.set_property(block_parameters.property, expression_engine.compute_expression(block_parameters.value))
	return true


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

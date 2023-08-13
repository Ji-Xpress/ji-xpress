extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	return false


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

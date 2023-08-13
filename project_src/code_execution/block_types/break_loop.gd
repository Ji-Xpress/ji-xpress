extends BlockTypeExecutionBase


## Computes which exit route it is meant to take
func compute_exit_block():
	return false


## Computes the result of the block's execution
func compute_result():
	return false


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return true

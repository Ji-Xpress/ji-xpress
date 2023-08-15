extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	var is_tween: bool = block_parameters.tween
	var tween_duration: float = 0
	var degrees: float = float(expression_engine.compute_expression(block_parameters.degrees_expression))
	
	if is_tween:
		tween_duration = float(expression_engine.compute_expression(block_parameters.tween_duration_expression))
		var tween: Tween = game_object_instance.create_tween()
		tween.tween_property(game_object_instance, "rotation_degrees", degrees, tween_duration)
	else:
		game_object_instance.rotation_degrees = degrees
		
	return true


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

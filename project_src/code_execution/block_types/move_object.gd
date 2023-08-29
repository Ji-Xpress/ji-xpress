extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	var is_tween: bool = block_parameters.tween
	var tween_duration: float = 0
	
	var x_expression_result = expression_engine.compute_expression(block_parameters.x_expression)
	var y_expression_result = expression_engine.compute_expression(block_parameters.y_expression)
	
	if x_expression_result != null and y_expression_result != null:
		var x: int = int(x_expression_result)
		var y: int = int(y_expression_result)
		
		if is_tween:
			tween_duration = float(expression_engine.compute_expression(block_parameters.tween_duration_expression))
			var tween: Tween = game_object_instance.create_tween()
			tween.tween_property(game_object_instance, "position", Vector2(x, y), tween_duration)
			await tween.finished
		else:
			game_object_instance.position = Vector2(x, y)
	
	return true


## Checks to see if the block reverts back to a finally
func is_reverting_to_finally():
	return false

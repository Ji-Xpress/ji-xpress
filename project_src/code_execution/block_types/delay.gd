extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Compute the message
	var computed_time = expression_engine.compute_expression(block_parameters.delay)
	
	if computed_time != null:
		# Create a new timer and run it
		var timer: Timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = float(computed_time)
		game_object_instance.add_child(timer)
		timer.start()
		
		await timer.timeout
		
		timer.queue_free()
	
	return true

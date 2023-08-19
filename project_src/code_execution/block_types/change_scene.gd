extends BlockTypeExecutionBase


## Computes the result of the block's execution
func compute_result():
	# Compute the message
	var scene_name = expression_engine.compute_expression(block_parameters.scene)
	
	# Signal a change scene
	var message_payload = NodeToCanvasMessages.construct_scene_change_message(scene_name + Constants.scene_extension)
	game_object_instance.object_functionality.send_message_to_canvas(message_payload)
	
	return true

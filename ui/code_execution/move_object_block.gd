extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_move_object
	
	# Slot metadata
	input_ports = {
		"0": condition_true
	}
	exit_ports = {
		"0": condition_true
	}
	exit_ports_with_results = {
		condition_true: 0
	}
	
	super._ready()


## Gets the metadata of the block
func get_block_metadata():
	return {
		"x_expression": $XExpression.text,
		"y_expression": $YExpression.text,
		"tween": $Tween.button_pressed,
		"tween_duration_expression": $TweenDurationExpression.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$XExpression.text = metadata.x_expression
	$YExpression.text = metadata.y_expression
	$Tween.button_pressed = metadata.tween
	$TweenDurationExpression.text = metadata.tween_duration_expression

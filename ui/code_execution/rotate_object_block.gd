extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_rotate_object
	
	# Slot metadata
	input_slots = {
		"0": null
	}
	exit_slots = {
		"0": null
	}
	
	super._ready()


## Gets the metadata of the block
func get_block_metadata():
	return {
		"degrees_expression": $DegreesExpression.text,
		"tween": $Tween.button_pressed,
		"tween_duration_expression": $TweenDurationExpression.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$DegreesExpression.text = metadata.degrees_expression
	$Tween.button_pressed = metadata.tween
	$TweenDurationExpression.text = metadata.tween_duration_expression

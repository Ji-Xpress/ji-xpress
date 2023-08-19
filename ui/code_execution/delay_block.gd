extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_delay
	super._ready()
	
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
	
	contains_true = true
	contains_false = false
	contains_finally = false


## Gets the metadata of the block
func get_block_metadata():
	return {
		"delay": $DelayExpression.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$DelayExpression.text = metadata.delay

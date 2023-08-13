extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_condition
	super._ready()
	
	# Slot metadata
	input_ports = {
		"0": condition_true
	}
	exit_ports = {
		"0": condition_true,
		"1": condition_false,
		"2": condition_finally
	}
	exit_ports_with_results = {
		condition_true: 0,
		condition_false: 1,
		condition_finally: 2
	}
	
	contains_true = true
	contains_false = true
	contains_finally = true


## Gets the metadata of the block
func get_block_metadata():
	return {
		"condition": $Condition.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$Condition.text = metadata.condition

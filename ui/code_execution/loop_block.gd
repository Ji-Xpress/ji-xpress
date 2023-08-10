extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_loop
	
	# Slot metadata
	input_slots = {
		"0": null
	}
	exit_slots = {
		"1": condition_true,
		"2": condition_finally
	}
	
	super._ready()


## Gets the metadata of the block
func get_block_metadata():
	return {
		"condition": $Condition.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$Condition.text = metadata.condition

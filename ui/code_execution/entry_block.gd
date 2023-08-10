extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_entry
	
	# Slot metadata
	exit_slots = {
		"0": condition_true
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

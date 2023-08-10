extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_set_object_property
	
	# Slot metadata
	input_slots = {
		"0": condition_true
	}
	exit_slots = {
		"0": condition_true
	}
	exit_slots_with_results = {
		condition_true: 0
	}
	
	super._ready()


## Gets the metadata of the block
func get_block_metadata():
	return {
		"property": $Property.text,
		"value": $Value.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$Property.text = metadata.property
	$Value.text = metadata.value

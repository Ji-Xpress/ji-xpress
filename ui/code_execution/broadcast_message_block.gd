extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_broadcast_message
	
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
		"message_id": $MessageID.text,
		"message": $Message.text
	}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	$MessageID.text = metadata.message_id
	$Message.text = metadata.message

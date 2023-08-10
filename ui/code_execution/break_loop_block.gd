extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_break_loop
	
	input_slots = {
		"0": null
	}
	
	super._ready()


## Gets the metadata of the block
func get_block_metadata():
	return null


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	return false

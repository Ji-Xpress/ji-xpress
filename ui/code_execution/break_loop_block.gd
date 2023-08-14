extends BlockBase


# Called when the node enters the scene tree for the first time.
func _ready():
	block_type = block_type_break_loop
	super._ready()
	
	input_ports = {
		"0": condition_true
	}
	
	contains_true = false
	contains_false = false
	contains_finally = false


## Gets the metadata of the block
func get_block_metadata():
	return {}


## Sets the metadata of the block
func set_block_metadata(metadata: Dictionary):
	return false

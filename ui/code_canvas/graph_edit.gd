extends GraphEdit

## Holder for the scene name
@export var script_name: String = ""
@export var is_new_file: bool = false

## Rasied when the scene invalidates itself
signal node_invalidated()
## Raised when the scene is saved
signal node_saved()
## Raised when there is a save error
signal node_save_error()


# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_new_file:
		load_script()


# Saves the script
func save_script():
	# Store data on all connections
	# Format: Array of { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	var all_connections: Array[Dictionary] = get_connection_list()
	# Metadata dictionary
	var metadata_dict = CodeExecutionEngine.model_template()
	
	for child_node in get_children():
		if child_node is BlockBase:
			var block_type: String = child_node.block_type
			var block_sub_type: String = child_node.block_sub_type
			var block_name: String = child_node.name
			# Fill in the block metadata
			var block_metdata: Dictionary = child_node.get_block_metadata()
			
			if block_metdata != null:
				if block_type == BlockBase.block_type_entry:
					# Entry block
					metadata_dict[CodeExecutionEngine.prop_entry_blocks][block_name] = block_metdata
				else:
					# Code block
					metadata_dict[CodeExecutionEngine.prop_code_blocks][block_name] = block_metdata
	
	metadata_dict[CodeExecutionEngine.prop_connections] = all_connections
	
	for connection in metadata_dict[CodeExecutionEngine.prop_connections]:
		var current_connection = metadata_dict[CodeExecutionEngine.prop_connections][connection]
		var connection_from_metadata = get_node(current_connection.from).get_input_slot_metadata(current_connection.from_port)
		var connection_to_metadata = get_node(current_connection.to).get_input_slot_metadata(current_connection.to_port)
		current_connection[CodeExecutionEngine.prop_connection_from_metadata] = connection_from_metadata
		current_connection[CodeExecutionEngine.prop_connection_to_metadata] = connection_to_metadata
	
	if ProjectManager.save_file_to_folder(script_name, true, [Constants.project_scripts_dir], JSON.stringify(metadata_dict)):
		emit_signal("node_saved")
		is_new_file = false
	else:
		emit_signal("node_save_error")


## Loads the script from the script file
func load_script():
	if script_name == "":
		var metadata_dict: Dictionary = ProjectManager.open_script(script_name)
		var entry_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_entry_blocks]
		var code_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_code_blocks]
		var connection_metadata: Array = metadata_dict[CodeExecutionEngine.prop_connections]
		
		for block_name in entry_blocks:
			pass
		
		for block_name in code_blocks:
			pass
		
		for connection in connection_metadata:
			pass


# When a connection request is made
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


# Disconnection request is made
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


# Node deletion requested
func _on_delete_nodes_request(nodes: Array):
	pass # Replace with function body.


# Node has been selected
func _on_node_selected(node: Node):
	pass # Replace with function body.


# Node has been deselected
func _on_node_deselected(node: Node):
	pass # Replace with function body.


# Node movement initiated
func _on_begin_node_move():
	pass # Replace with function body.


# Node movement ended
func _on_end_node_move():
	pass # Replace with function body.


# Track when a GraphNode enters
func _on_child_entered_tree(node: Node):
	var node_name = node.name

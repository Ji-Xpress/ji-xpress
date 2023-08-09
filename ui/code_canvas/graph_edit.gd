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
## When a mouse click is performed
signal mouse_clicked(button_index, canvas_position)

# Holds entry blocks
var entry_nodes: Dictionary = {}
# Holds code blocks
var code_blocks: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_new_file:
		load_script()


# Input handling
func _input(event):
	if event is InputEventMouseButton:
		var selected_add_position = event.position
		emit_signal("mouse_clicked", event.button_index, selected_add_position)


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
			var block_metadata: Dictionary = child_node.get_block_metadata()
			
			# Store position data
			block_metadata[BlockExecutionMetadata.prop_position_offset_x] = child_node.position_offset.x
			block_metadata[BlockExecutionMetadata.prop_position_offset_y] = child_node.position_offset.y
			
			if block_metadata != null:
				block_metadata[BlockExecutionMetadata.prop_block_id] = block_name
				if block_type == BlockBase.block_type_entry:
					# Entry block
					metadata_dict[CodeExecutionEngine.prop_entry_blocks][block_name] = block_metadata
				else:
					# Code block
					metadata_dict[CodeExecutionEngine.prop_code_blocks][block_name] = block_metadata
	
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
	if script_name != "":
		var metadata_dict: Dictionary = ProjectManager.open_script(script_name)
		var entry_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_entry_blocks]
		var code_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_code_blocks]
		var connection_metadata: Array = metadata_dict[CodeExecutionEngine.prop_connections]
		
		for block_name in entry_blocks:
			var block_metadata: Dictionary = entry_blocks[block_name]
			var block_instance = create_new_block_from_metadata(block_metadata)
			entry_blocks[block_instance.name] = block_instance
		
		for block_name in code_blocks:
			var block_metadata: Dictionary = code_blocks[block_name]
			var block_instance = create_new_block_from_metadata(block_metadata)
			code_blocks[block_instance.name] = block_instance
		
		for connection in connection_metadata:
			connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
		
		return true
	
	return false


## Gets the scene URL based on block type
func get_block_url_by_type(block_type):
	var block_scene_url: String = ""
	
	match block_type:
		BlockBase.block_type_break_loop:
			block_scene_url = "res://ui/code_execution/break_loop_block.tscn"
		BlockBase.block_type_broadcast_message:
			block_scene_url = "res://ui/code_execution/broadcast_message_block.tscn"
		BlockBase.block_type_condition:
			block_scene_url = "res://ui/code_execution/condition_block.tscn"
		BlockBase.block_type_entry:
			block_scene_url = "res://ui/code_execution/entry_block.tscn"
		BlockBase.block_type_function:
			block_scene_url = "res://ui/code_execution/function_block.tscn"
		BlockBase.block_type_loop:
			block_scene_url = "res://ui/code_execution/loop_block.tscn"
		BlockBase.block_type_move_object:
			block_scene_url = "res://ui/code_execution/move_object_block.tscn"
		BlockBase.block_type_rotate_object:
			block_scene_url = "res://ui/code_execution/rotate_object_block.tscn"
		BlockBase.block_type_set_global_variable:
			block_scene_url = "res://ui/code_execution/set_global_variable_block.tscn"
		BlockBase.block_type_set_object_property:
			block_scene_url = "res://ui/code_execution/set_object_property_block.tscn"
		BlockBase.block_type_set_object_variable:
			block_scene_url = "res://ui/code_execution/set_object_variable_block.tscn"
	
	return block_scene_url


## Creates a new block from a URL
func create_new_block_from_url(block_scene_url: String, block_position: Vector2):
	var block_instance: GraphNode = load(block_scene_url).instantiate()
	block_instance.position_offset = block_position
	
	call_deferred("add_child", block_instance)
	
	return block_instance


## Creates a new block from a metadata block
func create_new_block_from_metadata(block_metadata: Dictionary):
	var block_name: String = block_metadata[BlockExecutionMetadata.prop_block_id]
	var block_scene_url: String = get_block_url_by_type(block_metadata[BlockExecutionMetadata.prop_block_type])
	
	# Create the block
	var block_instance: GraphNode = load(block_scene_url).instantiate()
	block_instance.set_block_metadata(block_metadata)
	
	# Position the block
	var block_position = Vector2(block_metadata[BlockExecutionMetadata.prop_position_offset_x],
		block_metadata[BlockExecutionMetadata.prop_position_offset_y])
	block_instance.position_offset = block_position
	
	call_deferred("add_child", block_instance)
	
	return block_instance
	

# When a connection request is made
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	connect_node(from_node, from_port, to_node, to_port)


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

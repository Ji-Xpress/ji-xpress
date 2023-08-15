extends GraphEdit

## Holder for the scene name
@export var script_name: String = ""
## Holder for the object index
@export var object_index: int = -1
## Identifies if it is a new file
@export var is_new_file: bool = false

## Rasied when the scene invalidates itself
signal node_invalidated()
## Raised when the scene is saved
signal node_saved()
## Raised when there is a save error
signal node_save_error()
## When a right mouse click is performed
signal right_mouse_clicked(button_index, canvas_position)
## When a left mouse click is performed
signal left_mouse_clicked(button_index, canvas_position)

## Holds entry blocks
var entry_nodes: Dictionary = {}
## Holds code blocks
var code_blocks: Dictionary = {}
## Keeps track of all connections done
var connections: Dictionary = {}
## Keeps track of specific connections between nodes
var node_connections_from: Dictionary = {}
## Keeps track of specific connections between nodes
var node_connections_to: Dictionary = {}
## Contains reference to the current object instance
var current_object_instance: Node2D = null
## Keeps track of the last object index
var last_block_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_new_file:
		load_script()


# Capture Mouse Events
func _on_gui_input(event):
	if event is InputEventMouseButton:
		var selected_add_position = event.position + scroll_offset
		
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			emit_signal("right_mouse_clicked", event.button_index, selected_add_position)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("left_mouse_clicked", event.button_index, selected_add_position)


# Saves the script
func save_script():
	if script_name != "" and object_index > -1:
		# Store data on all connections
		# Format: Array of { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
		var all_connections: Array[Dictionary] = get_connection_list()
		# Metadata dictionary
		var metadata_dict = CodeExecutionEngine.model_template()
		metadata_dict[CodeExecutionEngine.prop_object_index] = object_index
		metadata_dict[CodeExecutionEngine.prop_last_block_index] = last_block_index
		
		for child_node in get_children():
			if child_node is BlockBase:
				var block_type: String = child_node.block_type
				var block_sub_type: String = child_node.block_sub_type
				var block_name: String = child_node.name
				# Fill in the block metadata
				var block_metadata: Dictionary = BlockExecutionMetadata.model_template()
				
				# Store routing metadata
				block_metadata[BlockExecutionMetadata.prop_block_type] = child_node.block_type
				block_metadata[BlockExecutionMetadata.prop_block_sub_type] = child_node.block_sub_type
				block_metadata[BlockExecutionMetadata.prop_block_parameters] = child_node.get_block_metadata()
				block_metadata[BlockExecutionMetadata.prop_input_port_metadata] = child_node.get_input_port_metadata()
				block_metadata[BlockExecutionMetadata.prop_exit_port_metadata] = child_node.get_exit_port_metadata()
				block_metadata[BlockExecutionMetadata.prop_exit_port_result_metadata] = child_node.get_exit_ports_with_results()
				block_metadata[BlockExecutionMetadata.prop_results_branching_metadata] = child_node.get_results_branching_metadata()
				
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
			var connection_from_metadata = get_node(NodePath(connection.from)).get_input_port_metadata(connection.from_port)
			var connection_to_metadata = get_node(NodePath(connection.to)).get_exit_port_metadata(connection.to_port)
			connection[CodeExecutionEngine.prop_connection_from_metadata] = connection_from_metadata
			connection[CodeExecutionEngine.prop_connection_to_metadata] = connection_to_metadata
		
		if ProjectManager.save_file_to_folder(script_name, false, [Constants.project_scripts_dir], JSON.stringify(metadata_dict)):
			emit_signal("node_saved")
			is_new_file = false
		else:
			emit_signal("node_save_error")
	else:
		emit_signal("node_save_error")


## Loads the script from the script file
func load_script():
	if script_name != "" and not is_new_file:
		connections = {}
		
		var metadata_dict: Dictionary = ProjectManager.open_script(script_name)
		var entry_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_entry_blocks]
		var code_blocks: Dictionary = metadata_dict[CodeExecutionEngine.prop_code_blocks]
		var connection_metadata: Array = metadata_dict[CodeExecutionEngine.prop_connections]
		
		# Manually set the last block index
		last_block_index = metadata_dict[CodeExecutionEngine.prop_last_block_index]
		
		for block_name in entry_blocks:
			var block_metadata: Dictionary = entry_blocks[block_name]
			var block_instance = create_new_block_from_metadata(block_metadata)
			block_instance.block_sub_type = block_metadata[BlockExecutionMetadata.prop_block_sub_type]
			
			block_instance.name = block_name
			add_child(block_instance)
			entry_blocks[block_name] = block_instance
		
		for block_name in code_blocks:
			var block_metadata: Dictionary = code_blocks[block_name]
			var block_instance = create_new_block_from_metadata(block_metadata)
			block_instance.block_sub_type = block_metadata[BlockExecutionMetadata.prop_block_sub_type]
			
			block_instance.name = block_name
			add_child(block_instance)
			code_blocks[block_name] = block_instance
		
		for connection in connection_metadata:
			connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
			connections[connection["from"] + "_" + str(connection["from_port"])] = true
			
			if not node_connections_from.has(connection["from"]):
				node_connections_from[connection["from"]] = []
			
			if not node_connections_to.has(connection["to"]):
				node_connections_to[connection["to"]] = []
			
			node_connections_from[connection["from"]].append({
				"from_port": connection["from_port"],
				"to_node": connection["to"],
				"to_port": connection["to_port"]
			})
			
			node_connections_to[connection["to"]].append({
				"from_port": connection["from_port"],
				"from_node": connection["from"],
				"to_port": connection["to_port"]
			})
			
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
func create_new_block_from_url(block_scene_url: String, block_position: Vector2, block_sub_type: String = ""):
	var block_instance: GraphNode = load(block_scene_url).instantiate()
	block_instance.position_offset = block_position
	block_instance.block_sub_type = block_sub_type
	
	return block_instance


## Creates a new block from a metadata block
func create_new_block_from_metadata(block_metadata: Dictionary):
	var block_name: String = block_metadata[BlockExecutionMetadata.prop_block_id]
	var block_scene_url: String = get_block_url_by_type(block_metadata[BlockExecutionMetadata.prop_block_type])
	
	# Create the block
	var block_instance: GraphNode = load(block_scene_url).instantiate()
	block_instance.set_block_metadata(block_metadata[BlockExecutionMetadata.prop_block_parameters])
	
	# Position the block
	var block_position = Vector2(block_metadata[BlockExecutionMetadata.prop_position_offset_x],
		block_metadata[BlockExecutionMetadata.prop_position_offset_y])
	block_instance.position_offset = block_position
	
	return block_instance
	

# When a connection request is made
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	if not connections.has(from_node + "_" + str(from_port)):
		connect_node(from_node, from_port, to_node, to_port)
		connections[from_node + "_" + str(from_port)] = true
		
		node_connections_from[from_node].append({
			"from_port": from_port,
			"to_node": to_node,
			"to_port": to_port
		})
		
		node_connections_to[to_node].append({
			"from_port": from_port,
			"from_node": from_node,
			"to_port": to_port
		})


# Disconnection request is made
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	disconnect_node(from_node, from_port, to_node, to_port)
	connections.erase(from_node + "_" + str(from_port))


# Track when a GraphNode enters
func _on_child_entered_tree(node: Node):
	if node is BlockBase:
		var node_name = node.name
		
		if not node_connections_from.has(node_name):
			node_connections_from[node_name] = []
		
		if not node_connections_to.has(node_name):
			node_connections_to[node_name] = []


# GraphEdit has an item exiting the tree
func _on_child_exiting_tree(node):
	if node is BlockBase:
		var node_name = node.name
		
		# Disconnect everything
		if node_connections_from.has(node_name):
			for connection in node_connections_from[node_name]:
				disconnect_node(node_name, connection.from_port, connection.to_node, connection.to_port)
				connections.erase(node_name + "_" + str(connection.from_port))
			
			node_connections_from.erase(node_name)
		
		if node_connections_to.has(node_name):
			for connection in node_connections_to[node_name]:
				disconnect_node(connection.from_node, connection.from_port, node_name, connection.to_port)
				connections.erase(connection.from_node + "_" + str(connection.from_port))
				
			node_connections_to.erase(node_name)

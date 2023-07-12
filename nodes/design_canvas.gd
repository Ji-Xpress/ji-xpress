extends Node2D

const canvas_mouse_hit_area = preload("res://nodes/canvas_mouse_hit_area.tscn")

@onready var node_instances: Node2D = $NodeInstances

var node_count: int = 0

# Signal for when a node is selected
signal node_selected(node: Node2D, node_index: int)
# Signal for when a node is selected
signal node_deselected(node: Node2D, node_index: int)
# Signal for when a node is selected
signal node_hover(node: Node2D, node_index: int)
# Signal for when a node is selected
signal node_hover_out(node: Node2D, node_index: int)

# The nodes that currently have a hover over them
var active_hover_nodes: Dictionary = {}
# The current active node
var current_active_node: Node2D = null


# A node has been clicked
func on_node_clicked(node: Node2D, node_index: int):
	var greater_node_index: int = -1
	var greater_node_reference: Node2D = null
	
	# Deactivate the selected rect
	if current_active_node != null:
		current_active_node.set_rect_extents_visibility(false)
	
	# Iterate through all active hover nodes and find the node that has the highest order
	for node_item in active_hover_nodes:
		var current_node = active_hover_nodes[node_item]
		if current_node.node_index_int > greater_node_index:
			# New higher order node found
			greater_node_index = current_node.node_index_int
			greater_node_reference = current_node.node
	
	# Record the current active node if found
	if greater_node_index > -1 and greater_node_reference != null:
		current_active_node = greater_node_reference
		current_active_node.set_rect_extents_visibility(true)
		
		# Emit node has been selected
		emit_signal("node_selected", node, node_index)
	
	await node_deselected


# A node has been clicked
func on_node_unclicked(node: Node2D, node_index: int):
	emit_signal("node_deselected", node, node_index)


# A node has hover focus
func on_node_hover(node: Node2D, node_index: int):
	var node_key = str(node_index)
	
	# If no node key exists for that index in the hover nodes, add it
	if not active_hover_nodes.has(node_key):
		var node_data = ActiveHoverNode.new()
		node_data.node = node
		node_data.node_index_int = node_index
		node_data.node_index_str = node_key
		
		active_hover_nodes[node_key] = node_data
	
	# Emit node has been hovered
	emit_signal("node_hover", node, node_index)


# A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	var node_key = str(node_index)
	
	# Remove the node index in the hover nodes if the key exists
	if active_hover_nodes.has(node_key):
		active_hover_nodes.erase(node_key)
	
	# Emit node has been hovered out
	emit_signal("node_hover_out", node, node_index)


# Adding a new node to the node tree
func add_new_node(new_node: Node2D):
	# Check to see if it has the RectExtents2D child
	if new_node.has_node("RectExtents2D"):
		# Check to see if the RectExtents2D child node is of the correct type
		var rect_extents_node: Node2D = new_node.get_node("RectExtents2D")
		if rect_extents_node is RectExtents2D:
			# Make the rect_extents node invisible by default
			rect_extents_node.visible = false
			
			# Create a hit area with the same size and position as the rect extents node
			var extents_size: Vector2 = rect_extents_node.size
			var extents_position: Vector2 = rect_extents_node.position
			
			var new_hit_area = canvas_mouse_hit_area.instantiate()
			new_hit_area.position = extents_position
			new_hit_area.set_hit_size(extents_size)
			new_hit_area.node_index = node_count
			new_node.call_deferred("add_child", new_hit_area)
			
			# Connect the signals form the hit area for handling
			new_hit_area.connect("node_clicked", Callable(self, "on_node_clicked"))
			new_hit_area.connect("node_unclicked", Callable(self, "on_node_unclicked"))
			new_hit_area.connect("node_hover", Callable(self, "on_node_hover"))
			new_hit_area.connect("node_hover_out", Callable(self, "on_node_hover_out"))
			
			# Add the new node to the canvas
			call_deferred("add_child", new_node)
			
			# Increase node count
			node_count += 1

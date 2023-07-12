extends Control

const selectable_spite_node = preload("res://tests/selectable_sprite_node.tscn")

# Design Canvas
@onready var design_canvas: Node2D = $VBoxContainer/SubViewportContainer/SubViewport/DesignCanvas

# When a new node is added what positional offset will it have?
var position_offset: Vector2 = Vector2(0, 0)

# The nodes that currently have a hover over them
var active_hover_nodes: Dictionary = {}
# The current active node
var current_active_node: Node2D = null


# Node is ready
func _ready():
	# Connect signals
	design_canvas.connect("node_selected", Callable(self, "on_node_selected"))
	design_canvas.connect("node_deselected", Callable(self, "on_node_deselected"))
	design_canvas.connect("node_hover", Callable(self, "on_node_hover"))
	design_canvas.connect("node_hover_out", Callable(self, "on_node_hover_out"))


# A node has been clicked
func on_node_selected(node: Node2D, node_index: int):
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
		
		# debug
		print("selected " + str(node_index))
	
	await design_canvas.node_deselected


# A node has been clicked
func on_node_deselected(node: Node2D, node_index: int):
	# debug
	print("deselected " + str(node_index))


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
	
	# debug
	print("hover " + str(node_index))


# A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	var node_key = str(node_index)
	
	# Remove the node index in the hover nodes if the key exists
	if active_hover_nodes.has(node_key):
		active_hover_nodes.erase(node_key)
	
	# debug
	print("hover out " + str(node_index))


# Test: Add a new test node
func _on_add_sprite_node_pressed():
	var new_node: Node2D = selectable_spite_node.instantiate()
	new_node.position += position_offset
	position_offset += Vector2(20, 20)
	design_canvas.add_new_node(new_node)

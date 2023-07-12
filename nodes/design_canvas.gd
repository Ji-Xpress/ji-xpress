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


# A node has been clicked
func on_node_clicked(node: Node2D, node_index: int):
	emit_signal("node_selected", node, node_index)


# A node has been clicked
func on_node_unclicked(node: Node2D, node_index: int):
	emit_signal("node_deselected", node, node_index)


# A node has hover focus
func on_node_hover(node: Node2D, node_index: int):
	emit_signal("node_hover", node, node_index)


# A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	emit_signal("node_hover_out", node, node_index)


# Adding a new node to the node tree
func add_new_node(new_node: Node2D):
	if new_node.has_node("RectExtents2D"):
		var rect_extents_node: Node2D = new_node.get_node("RectExtents2D")
		if rect_extents_node is RectExtents2D:
			# Make the rect_extents node invisible
			rect_extents_node.visible = false
			
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
			
			call_deferred("add_child", new_node)
			
			# Increase node count
			node_count += 1

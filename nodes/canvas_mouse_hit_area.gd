extends Area2D

# Node signals
signal node_clicked(node: Node2D, node_index: int)
signal node_unclicked(node: Node2D, node_index: int)
signal node_hover(node: Node2D, node_index: int)
signal node_hover_out(node: Node2D, node_index: int)

var parent_node: Node2D = null


# Initialization
func _ready():
	parent_node = get_parent()


# Hit area size
func set_hit_size(vector: Vector2) -> void:
	$CollisionShape2D.shape.size = vector


# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_clicked", parent_node, parent_node.node_index)
	elif (event is InputEventMouseButton and not event.pressed):
		emit_signal("node_unclicked", parent_node, parent_node.node_index)


# Mouse entred the hit box area
func _on_mouse_entered():
	emit_signal("node_hover", parent_node, parent_node.node_index)


# Mouse left the hitbox area
func _on_mouse_exited():
	emit_signal("node_hover_out", parent_node, parent_node.node_index)

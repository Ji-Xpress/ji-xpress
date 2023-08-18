extends Area2D

# Node signals
signal node_clicked(node: Node2D, node_index: int)
signal node_unclicked(node: Node2D, node_index: int)
signal node_hover(node: Node2D, node_index: int)
signal node_hover_out(node: Node2D, node_index: int)

var parent_node: Node2D = null
var hit_box_size: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Initialization
func _ready():
	parent_node = get_parent()
	collision_shape.shape.size = hit_box_size


# Hit area size
func set_hit_size(vector: Vector2, force_on_shape: bool = false) -> void:
	hit_box_size = vector
	
	if force_on_shape:
		collision_shape.shape.size = hit_box_size


# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_clicked", parent_node, parent_node.object_metadata.node_index)
	elif (event is InputEventMouseButton and not event.pressed):
		emit_signal("node_unclicked", parent_node, parent_node.object_metadata.node_index)


# Mouse entred the hit box area
func _on_mouse_entered():
	emit_signal("node_hover", parent_node, parent_node.object_metadata.node_index)


# Mouse left the hitbox area
func _on_mouse_exited():
	emit_signal("node_hover_out", parent_node, parent_node.object_metadata.node_index)

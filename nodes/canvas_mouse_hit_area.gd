extends Area2D

signal node_clicked(node: Node2D, node_index: int)
signal node_unclicked(node: Node2D, node_index: int)
signal node_hover(node: Node2D, node_index: int)
signal node_hover_out(node: Node2D, node_index: int)

var node_index: int = 0


# Hit area size
func set_hit_size(vector: Vector2) -> void:
	$CollisionShape2D.shape.size = vector


# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_clicked", get_parent(), node_index)
	elif (event is InputEventMouseButton and not event.pressed):
		emit_signal("node_unclicked", get_parent(), node_index)


func _on_mouse_entered():
	emit_signal("node_hover", get_parent(), node_index)


func _on_mouse_exited():
	emit_signal("node_hover_out", get_parent(), node_index)

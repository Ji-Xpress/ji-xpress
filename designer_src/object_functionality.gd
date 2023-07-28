extends Node
class_name ObjectFunctionality

## Reference to parent node
var parent_node: Node2D = null


# Initialization
func _ready():
	parent_node = get_parent()


# Sets the visibility of rect extents
func set_rect_extents_visibility(visibility: bool):
	parent_node.get_node("RectExtents2D").visible = visibility


# Requests a change to the scene
func send_message_to_canvas(message: Dictionary):
	var node_kind: SharedEnums.ObjectLayer = parent_node.object_metadata.node_kind
	
	if node_kind == SharedEnums.ObjectLayer.LayerBackground:
		parent_node.get_parent().get_parent().get_parent().emit_signal("send_node_message", parent_node, message)
	else:
		parent_node.get_parent().get_parent().emit_signal("send_node_message", parent_node, message)

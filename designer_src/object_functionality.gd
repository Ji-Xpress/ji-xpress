extends Node
class_name ObjectFunctionality

## Reference to parent node
var parent_node: Node2D = null

func _ready():
	parent_node = get_parent()


# Sets the visibility of rect extents
func set_rect_extents_visibility(visibility: bool):
	parent_node.get_node("RectExtents2D").visible = visibility

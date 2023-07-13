extends Sprite2D

@onready var rect_extents_2d: RectExtents2D = $RectExtents2D

# Node Kind variable
var node_kind: ActiveHoverNode.NodeKind = ActiveHoverNode.NodeKind.foreground

# Current numeric node index: Used for Canvas order tracking
var node_index: int = 0

# In design mode or in run mode
var node_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign


## Makes the rect extents visible or not
func set_rect_extents_visibility(visibility: bool):
	rect_extents_2d.visible = visibility

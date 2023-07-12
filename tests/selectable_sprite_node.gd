extends Sprite2D

@onready var rect_extents_2d: RectExtents2D = $RectExtents2D

## Makes the rect extents visible or not
func set_rect_extents_visibility(visibility: bool):
	rect_extents_2d.visible = visibility

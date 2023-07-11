@tool
extends EditorPlugin

const RectExtents2D = preload("res://addons/rect_extents_2D/RectExtents2D.gd")
const Anchor = preload("res://addons/rect_extents_2D/Anchor.gd")



var rect_extents : RectExtents2D
var anchors : Array
var dragged_anchor : Anchor
# previous drag state
var drag_start : Dictionary = {
	'size': Vector2(),
}



#== node ==
func _enter_tree() -> void:
	add_custom_type("RectExtents2D", "Node2D", preload("RectExtents2D.gd"), preload("icon.svg"))

func _exit_tree() -> void:
	remove_custom_type("RectExtents2D")



#== plugin ==
func _edit(object: Object) -> void:
	rect_extents = object


func _make_visible(visible : bool) -> void:
	if not rect_extents:
		return
	
	if not visible:
		rect_extents = null
	
	update_overlays()


func _handles(object : Object) -> bool:
	return object is RectExtents2D


func _forward_canvas_draw_over_viewport(overlay: Control) -> void:
	if not rect_extents or not rect_extents.is_inside_tree():
		return
	
	var pos = rect_extents.position
	var half_size : Vector2 = rect_extents.size / 2.0
	# Top-Left, Top-Right, Bottom-Right, Bottom-Left
	var edit_anchors : Array = [
		pos - half_size,
		pos + Vector2(half_size.x, half_size.y * -1.0),
		pos + Vector2(half_size.x * -1.0, half_size.y),
		pos + half_size,
	]
	
	var transform_viewport := rect_extents.get_viewport_transform()
	var transform_global := rect_extents.get_canvas_transform()
	
	anchors = []
	
	# add all corners anchors
	for coord in edit_anchors:
		var anchor_center : Vector2 = transform_viewport * (transform_global * coord)
		var new_anchor : Anchor = Anchor.new(anchor_center)
		
		new_anchor.draw(overlay, rect_extents.color)
		anchors.append(new_anchor)


func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if not rect_extents or not rect_extents.visible:
		return false
	
	# Clicking and releasing the click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not dragged_anchor and event.is_pressed():
			for anchor in anchors:
				if not anchor['rect'].has_point(event.position):
					continue
				dragged_anchor = anchor
				print("Drag start: %s" % dragged_anchor)
				drag_start = { 'size': rect_extents.size }
				return true
		elif dragged_anchor and not event.is_pressed():
			drag_to(event.position)
			dragged_anchor = null
			var undo := get_undo_redo()
			undo.create_action("Move anchor")
		
			undo.add_do_property(rect_extents, "size", rect_extents.size)
			undo.add_undo_property(rect_extents, "size", drag_start['size'])
		
			undo.commit_action()
			return true
	
	if not dragged_anchor:
		return false
	
	# Dragging
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		drag_to(event.position)
		update_overlays()
		return true
	# Cancelling with ui_cancel
	if event.is_action_pressed("ui_cancel"):
		dragged_anchor = null
		return true
	return false


#== functions ==
func drag_to(event_position: Vector2) -> void:
	if not dragged_anchor:
		return
	# Calculate the position of the mouse cursor relative to the RectExtents' center
	var viewport_transform_inv := rect_extents.get_viewport().get_global_canvas_transform().affine_inverse()
	var viewport_position: Vector2 = viewport_transform_inv * event_position
	var transform_inv := rect_extents.get_global_transform().affine_inverse()
	var target_position: Vector2 = transform_inv * viewport_position.round()
	# Update the rectangle's size. Only resizes uniformly around the center for now
	var target_size = (target_position).abs() * 2.0
	rect_extents.size = target_size
	rect_extents.queue_redraw()

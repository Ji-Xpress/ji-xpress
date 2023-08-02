extends Node2D

const canvas_mouse_hit_area = preload("res://designer_nodes/canvas_mouse_hit_area.tscn")

## Grid snapping. If set it snaps the object movement
@export var grid_snapping: Vector2 = Vector2(1, 1)
## Override node selection operations
@export var override_node_selection: bool = false
## The current canvas mode
@export var canvas_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign

# Node references
## Node to store foreground nodes
@onready var foreground: Node2D = $Foreground
## Node to store background nodes
@onready var background: Node2D = $Background/Nodes
## Node to store tiles
@onready var tiles: Node2D = $Tiles
## Canavs overlays to aid in design process
@onready var canvas_overlays: Node2D = $CanvasOverlays
## Reference to the current camera
@onready var camera: Camera2D = $Camera2D

## Tracks the number of nodes currently added to canvas
var node_count: int = -1

## Signal for when a node is added
signal node_added(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when a node is selected
signal node_selected(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when a node is selected
signal node_deselected(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when a node is selected
signal node_hover(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when a node is selected
signal node_hover_out(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when node is rotated
signal node_rotated(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for when node is moved
signal node_moved(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Signal for a node delete
signal node_deleted(node: Node2D, object_id: String, node_index: int, node_kind: ActiveHoverNode.NodeKind)
## Emitted when all nodes are deactivated using the ESC button
signal all_nodes_deselected()
## Signal for when the mouse button is pressed on canvas
signal mouse_clicked(mouse_button: int, mouse_position: Vector2)
## Signal for when the mouse button is released on canvas
signal mouse_released(mouse_button: int, mouse_position: Vector2)
## Used when a child node needs to send a message to the outside world
signal send_node_message(node: Node2D, message: Dictionary)

## The nodes that currently have a hover over them
var active_hover_nodes_foreground: Dictionary = {}
## The nodes that currently have a hover over them
var active_hover_nodes_tiles: Dictionary = {}
## The nodes that currently have a hover over them
var active_hover_nodes_backgound: Dictionary = {}

## The current active node
var current_active_node: Node2D = null

## Track is mouse down or not
var is_mouse_down: bool = false
## Panning the viewport
var is_panning: bool = false
## Ctrl key down
var is_ctrl_key_down: bool = false
## Dragging a node
var is_dragging_node: bool = false

# For panning
var mouse_pan_start_position: Vector2 = Vector2.ZERO
var pan_screen_start_position: Vector2 = Vector2.ZERO

## For node dragging
var node_drag_start_position: Vector2 = Vector2.ZERO

## For tracking the current mouse position
var current_canvas_mouse_position: Vector2 = Vector2.ZERO


# Initalize
func _ready():
	# Turn off canvas camera in run mode
	if canvas_mode == SharedEnums.NodeCanvasMode.ModeRun:
		camera.enabled = false
		canvas_overlays.visible = false
	else:
		camera.enabled = true
		canvas_overlays.visible = true


# Track mouse events
func _input(event):
	# Generic event handling
	if canvas_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		if (event is InputEventMouseButton and event.pressed):
			emit_signal("mouse_clicked", event.button_index, event.position)
		elif (event is InputEventMouseButton and not event.pressed):
			emit_signal("mouse_released", event.button_index, event.position)
		
		# Track the current mouse position
		if (event is InputEventMouseMotion):
			current_canvas_mouse_position = event.position
		
		# Handling panning (Mouse Middle Button)
		# Panning is handled by middle mouse button being down or ctrl + left click
		if (event is InputEventMouseButton and event.pressed and ((event.button_index == MOUSE_BUTTON_MIDDLE) or \
			(event.button_index == MOUSE_BUTTON_LEFT and is_ctrl_key_down))):
			is_panning = true
			mouse_pan_start_position = event.position
			pan_screen_start_position = camera.position
		elif (event is InputEventMouseButton and not event.pressed and ((event.button_index == MOUSE_BUTTON_MIDDLE) or \
			(event.button_index == MOUSE_BUTTON_LEFT and is_ctrl_key_down))):
			is_panning = false
			mouse_pan_start_position = Vector2.ZERO
			pan_screen_start_position = Vector2.ZERO
		
		# When the mouse press is released anywhere in the screen
		# We need to deactivate all flags
		if (event is InputEventMouseButton and not event.pressed):
			if is_dragging_node and current_active_node != null:
				emit_signal("node_moved", current_active_node, current_active_node.object_metadata.node_index, current_active_node.object_metadata.node_kind)
			
			is_mouse_down = false
			is_dragging_node = false
			node_drag_start_position = Vector2.ZERO
		
		# Mouse motion events
		# This section handles viewport panning and also dragging
		if event is InputEventMouseMotion and is_panning:
			# Viewport panning
			camera.position = (camera.zoom * (mouse_pan_start_position - event.position) + pan_screen_start_position)
		elif event is InputEventMouseMotion and is_dragging_node:
			# Moving the current active node
			if current_active_node != null:
				current_active_node.position += (event.position - node_drag_start_position)
				current_active_node.position = current_active_node.position.snapped(grid_snapping)
				node_drag_start_position = event.position.snapped(grid_snapping)
		
		# Keyboard events
		# In this section we track the use of <ESC> key and <Ctrl> key
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_ESCAPE:
				# Escape key handling - ESC down
				if current_active_node != null:
					emit_signal("node_deselected", current_active_node, current_active_node.object_metadata.node_kind, current_active_node.object_metadata.node_index)
					emit_signal("all_nodes_deselected")
					# Reset selected node status
					current_active_node.object_functionality.set_rect_extents_visibility(false)
					current_active_node = null
			elif event.keycode == KEY_DELETE:
				# Delete key pressed. Handle if we need to delete a node
				if current_active_node != null:
					delete_node(current_active_node)
			elif event.keycode == KEY_CTRL:
				# Track if ctrl key is pressed
				is_ctrl_key_down = true
		elif event is InputEventKey and not event.pressed:
			if event.keycode == KEY_CTRL:
				# Track if ctrl key is released
				is_ctrl_key_down = false


# Delete an active node
func delete_node(node: Node2D):
	var is_current_node: bool = (node == current_active_node)
	var node_kind: ActiveHoverNode.NodeKind = node.object_metadata.node_kind
	var node_index: int = node.object_metadata.node_index
	var object_id: String = node.object_metadata.object_id
	
	# Remove from the relevant tree sub item
	match node_kind:
		ActiveHoverNode.NodeKind.foreground:
			active_hover_nodes_foreground.erase(str(node_index))
			foreground.remove_child(node)
		ActiveHoverNode.NodeKind.tile:
			active_hover_nodes_tiles.erase(str(node_index))
			tiles.remove_child(node)
			return tiles.get_children()
		ActiveHoverNode.NodeKind.background:
			active_hover_nodes_backgound.erase(str(node_index))
			background.remove_child(node)
	
	# Notify of node deletion to parent
	emit_signal("node_deleted", node, object_id, node_index, node_kind)
	# Delete object
	node.queue_free()
	# Notify to clear canvas if it was current active node
	if is_current_node:
		emit_signal("all_nodes_deselected")


## Returns all nodes of requested type
func get_all_nodes(node_group: ActiveHoverNode.NodeKind):
	match node_group:
		ActiveHoverNode.NodeKind.foreground:
			return foreground.get_children()
		ActiveHoverNode.NodeKind.tile:
			return tiles.get_children()
		ActiveHoverNode.NodeKind.background:
			return background.get_children()


## Scans a group of tiles to present which one is being selected
func scan_hovered_nodes(node_group: Dictionary):
	var greater_node_index: int = -1
	var greater_node_node: Node2D = null
	
	for node_item in node_group:
		var current_node = node_group[node_item]
		if current_node.node_index_int > greater_node_index:
			greater_node_index = current_node.node_index_int
			greater_node_node = current_node.node
	
	if greater_node_index > -1 and greater_node_node != null:
		# New higher order node found
		return greater_node_node
		
	return null


## Scans an ordered array of tile groups and presents the first result
func scan_node_group_array(node_group_array: Array):
	for node_group in node_group_array:
		var node_result: Object = scan_hovered_nodes(node_group)
		if node_result != null:
			return node_result
	
	return null


## Event handler - A node has been clicked
func on_node_clicked(node: Node2D, node_index: int):
	# These events are notorious for firing multiple times esp for overlapping controls
	# So we need to block this if the mouse down event is already handled
	if not is_mouse_down and not is_ctrl_key_down and not override_node_selection:
		# Deactivate the selected rect
		if current_active_node != null:
			current_active_node.object_functionality.set_rect_extents_visibility(false)
		
		# Iterate through all active hover nodes and find the node that has the highest order
		var node_group_search_order: Array = [
			active_hover_nodes_foreground,
			active_hover_nodes_tiles,
			active_hover_nodes_backgound
		]
		
		var node_search: Node2D = scan_node_group_array(node_group_search_order)
		
		if node_search != null:
			# Mouse is down on selected node
			is_mouse_down = true
			is_dragging_node = true
			
			# Set current active node
			current_active_node = node_search
			current_active_node.object_functionality.set_rect_extents_visibility(true)
			
			# Initiate the drag position
			node_drag_start_position = get_viewport().get_mouse_position()
			
			# Emit node has been selected
			emit_signal("node_selected", node, node_index, current_active_node.object_metadata.node_kind)


## Event handler - A node has been unclicked
func on_node_unclicked(node: Node2D, node_index: int):
	# Allow click processing
	emit_signal("node_deselected", node, node_index, node.object_metadata.node_kind)


## Event handler - A node has hover focus
func on_node_hover(node: Node2D, node_index: int):
	var node_key = str(node_index)
	var node_kind: ActiveHoverNode.NodeKind = node.object_metadata.node_kind
	
	var node_data = ActiveHoverNode.new()
	node_data.node = node
	node_data.node_index_int = node_index
	node_data.node_index_str = node_key
	node_data.node_kind = node_kind
	
	# If no node key exists for that index in the hover nodes, add it
	match node_kind:
		ActiveHoverNode.NodeKind.foreground:
			if not active_hover_nodes_foreground.has(node_key):
				active_hover_nodes_foreground[node_key] = node_data
		ActiveHoverNode.NodeKind.tile:
			if not active_hover_nodes_tiles.has(node_key):
				active_hover_nodes_tiles[node_key] = node_data
		ActiveHoverNode.NodeKind.background:
			if not active_hover_nodes_backgound.has(node_key):
				active_hover_nodes_backgound[node_key] = node_data
	
	# Emit node has been hovered
	emit_signal("node_hover", node, node_index, node_kind)


## Event handler - A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	var node_key = str(node_index)
	var node_kind: ActiveHoverNode.NodeKind = node.object_metadata.node_kind
	
	# Remove the node index in the hover nodes if the key exists
	match node_kind:
		ActiveHoverNode.NodeKind.foreground:
			if active_hover_nodes_foreground.has(node_key):
				active_hover_nodes_foreground.erase(node_key)
		ActiveHoverNode.NodeKind.tile:
			if active_hover_nodes_tiles.has(node_key):
				active_hover_nodes_tiles.erase(node_key)
		ActiveHoverNode.NodeKind.background:
			if active_hover_nodes_backgound.has(node_key):
				active_hover_nodes_backgound.erase(node_key)
	
	# Emit node has been hovered out
	emit_signal("node_hover_out", node, node_index, node_kind)


## Adds a new node to the node tree
func add_new_node(new_node: Node2D, node_kind: \
	ActiveHoverNode.NodeKind = ActiveHoverNode.NodeKind.foreground, \
	node_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign,
	node_index: int = -1) -> int:
	# Check to see if it has the RectExtents2D child
	if new_node.has_node("RectExtents2D"):
		# Check to see if the RectExtents2D child node is of the correct type
		var rect_extents_node: Node2D = new_node.get_node("RectExtents2D")
		if rect_extents_node is RectExtents2D:
			# Increase node count if it is a new node
			if node_index < 0:
				node_count += 1
			
			# Make the rect_extents node invisible by default
			rect_extents_node.visible = false
			
			# Set node level properties
			# Set the node index
			var object_metadata_node: Node = new_node.get_node("ObjectMetaData")
			
			# Set the position and rotation
			new_node.position = Vector2(object_metadata_node.position_x, object_metadata_node.position_y)
			new_node.rotation_degrees = object_metadata_node.rotation
			
			# Set the node index
			if node_index > -1:
				object_metadata_node.node_index = node_index
			else:
				object_metadata_node.node_index = node_count
			
			# Explicity set the node kind
			object_metadata_node.node_kind = node_kind
			# Set node mode
			object_metadata_node.node_mode = node_mode
			# Prepare a dictionary of all custom properties in the metadata
			object_metadata_node.prepare_custom_prop_dict(false)
			
			## Only create a hit area if we are in design mode
			if node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
				# Create a hit area with the same size and position as the rect extents node
				var extents_size: Vector2 = rect_extents_node.size
				var extents_position: Vector2 = rect_extents_node.position
				
				var new_hit_area = canvas_mouse_hit_area.instantiate()
				new_hit_area.position = extents_position
				new_hit_area.set_hit_size(extents_size)
				new_node.call_deferred("add_child", new_hit_area)
				
				# Connect the signals form the hit area for handling
				new_hit_area.connect("node_clicked", Callable(self, "on_node_clicked"))
				new_hit_area.connect("node_unclicked", Callable(self, "on_node_unclicked"))
				new_hit_area.connect("node_hover", Callable(self, "on_node_hover"))
				new_hit_area.connect("node_hover_out", Callable(self, "on_node_hover_out"))
			else:
				# Hide rect extents in run mode
				rect_extents_node.visible = false
			
			# Add the new node to the canvas
			match node_kind:
				ActiveHoverNode.NodeKind.foreground:
					foreground.call_deferred("add_child", new_node)
				ActiveHoverNode.NodeKind.tile:
					tiles.call_deferred("add_child", new_node)
				ActiveHoverNode.NodeKind.background:
					background.call_deferred("add_child", new_node)

			# Notify of an added node
			emit_signal("node_added", new_node, node_count, node_kind)
			
			# Is the node index set manally?
			if node_index > -1:
				return node_index
			else:
				return node_count
	
	return -1


## Sets the current selected node rotation
func set_current_node_rotation(degrees: int):
	if current_active_node != null:
		current_active_node.rotation_degrees = degrees
		emit_signal("node_rotated", current_active_node, current_active_node.object_metadata.node_index, current_active_node.object_metadata.node_kind)

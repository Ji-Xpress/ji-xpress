extends Node2D

const canvas_mouse_hit_area = preload("res://nodes/canvas_mouse_hit_area.tscn")

@export var grid_snapping: Vector2 = Vector2(1, 1)

# Node references
@onready var foreground: Node2D = $Foreground
@onready var background: Node2D = $Background/Nodes
@onready var tiles: Node2D = $Tiles
@onready var camera: Camera2D = $Camera2D

var node_count: int = -1

# Signal for when a node is selected
signal node_selected(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
# Signal for when a node is selected
signal node_deselected(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
# Signal for when a node is selected
signal node_hover(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
# Signal for when a node is selected
signal node_hover_out(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
# Signal for when node is rotated
signal node_rotated(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)
# Signal for when node is moved
signal node_moved(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind)

# The nodes that currently have a hover over them
var active_hover_nodes_foreground: Dictionary = {}
# The nodes that currently have a hover over them
var active_hover_nodes_tiles: Dictionary = {}
# The nodes that currently have a hover over them
var active_hover_nodes_backgound: Dictionary = {}

# The current active node
var current_active_node: Node2D = null

# Track is mouse down or not
var is_mouse_down: bool = false
# Panning the viewport
var is_panning: bool = false
# Dragging a node
var is_dragging_node: bool = false

# For panning
var mouse_pan_start_position: Vector2 = Vector2.ZERO
var pan_screen_start_position: Vector2 = Vector2.ZERO

# For node dragging
var node_drag_start_position: Vector2 = Vector2.ZERO


# Track mouse events
func _input(event):
	# Handling panning (Mouse Middle Button)
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE):
		is_panning = true
		mouse_pan_start_position = event.position
		pan_screen_start_position = camera.position
	elif (event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE):
		is_panning = false
		mouse_pan_start_position = Vector2.ZERO
		pan_screen_start_position = Vector2.ZERO
	
	# When the mouse press is released anywhere in the screen
	if (event is InputEventMouseButton and not event.pressed):
		if is_dragging_node and current_active_node != null:
			emit_signal("node_moved", current_active_node, current_active_node.node_index, current_active_node.node_kind)
		
		is_mouse_down = false
		is_dragging_node = false
		node_drag_start_position = Vector2.ZERO
	
	# Mouse motion events
	if event is InputEventMouseMotion and is_panning:
		# Viewport panning
		camera.position = (camera.zoom * (mouse_pan_start_position - event.position) + pan_screen_start_position)
	elif event is InputEventMouseMotion and is_dragging_node:
		# Moving the current active node
		if current_active_node != null:
			current_active_node.position += (event.position - node_drag_start_position).snapped(grid_snapping)
			node_drag_start_position = event.position.snapped(grid_snapping)
	
	# Keyboard events
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if current_active_node != null:
				emit_signal("node_deselected", current_active_node, current_active_node.node_index)
				# Reset selected node status
				current_active_node.set_rect_extents_visibility(false)
				current_active_node = null


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


# A node has been clicked
func on_node_clicked(node: Node2D, node_index: int):
	# These events are notorious for firing multiple times esp for overlapping controls
	# So we need to block this if the mouse down event is already handled
	if not is_mouse_down:
		# Deactivate the selected rect
		if current_active_node != null:
			current_active_node.set_rect_extents_visibility(false)
		
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
			current_active_node.set_rect_extents_visibility(true)
			
			# Initiate the drag position
			node_drag_start_position = get_viewport().get_mouse_position()
			
			# Emit node has been selected
			emit_signal("node_selected", node, node_index)


# A node has been clicked
func on_node_unclicked(node: Node2D, node_index: int):
	# Allow click processing
	emit_signal("node_deselected", node, node_index)


# A node has hover focus
func on_node_hover(node: Node2D, node_index: int):
	var node_key = str(node_index)
	var node_kind: ActiveHoverNode.NodeKind = node.node_kind
	
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
	emit_signal("node_hover", node, node_index)


# A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	var node_key = str(node_index)
	var node_kind: ActiveHoverNode.NodeKind = node.node_kind
	
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
	emit_signal("node_hover_out", node, node_index)


## Adds a new node to the node tree
func add_new_node(new_node: Node2D, node_kind: \
	ActiveHoverNode.NodeKind = ActiveHoverNode.NodeKind.foreground, \
	node_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign) -> int:
	# Check to see if it has the RectExtents2D child
	if new_node.has_node("RectExtents2D"):
		# Check to see if the RectExtents2D child node is of the correct type
		var rect_extents_node: Node2D = new_node.get_node("RectExtents2D")
		if rect_extents_node is RectExtents2D:
			# Increase node count
			node_count += 1
			
			# Make the rect_extents node invisible by default
			rect_extents_node.visible = false
			
			# Set node level properties
			# Set the node index
			new_node.node_index = node_count
			# Explicity set the node kind
			new_node.node_kind = node_kind
			# Set node mode
			new_node.node_mode = node_mode
			
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
			
			# Add the new node to the canvas
			match node_kind:
				ActiveHoverNode.NodeKind.foreground:
					foreground.call_deferred("add_child", new_node)
				ActiveHoverNode.NodeKind.tile:
					tiles.call_deferred("add_child", new_node)
				ActiveHoverNode.NodeKind.background:
					background.call_deferred("add_child", new_node)
			
			return node_count
	
	return -1


## Sets the current selected node rotation
func set_current_node_rotation(degrees: int):
	if current_active_node != null:
		current_active_node.rotation_degrees = degrees
		emit_signal("node_rotated", current_active_node, current_active_node.node_index, current_active_node.node_kind)

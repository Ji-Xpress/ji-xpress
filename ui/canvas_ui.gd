extends Control

## Holder for the scene name
@export var scene_name: String = ""

## Canvas UI mode
@export var canvas_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign

# Node references
@onready var properties_editor: Control = %PropertiesEditor
@onready var design_canvas: Node2D = %DesignCanvas
@onready var tab_common: Node = $TabCommon
@onready var right_panel: Control = $PanelContainer/HSplitContainer/RightPanel
@onready var canvas_menu: Control = $PanelContainer/HSplitContainer/LeftPanel/ControlContainer/CanvasMenu
@onready var popup_menu: PopupMenu = $PopupMenu

## When the add node button is pressed
signal add_node_pressed(node_instance: Control, request_position)
## When the save scene button is pressed
signal save_scene_pressed(node_instance: Control)
## When the canvas settings button is pressed
signal canvas_settings_pressed(node_instance: Control)
## When the tab is being closed
signal tab_close_request(node_instance: Control, scene_id: String)
## Node sends message to design canvas
signal design_canvas_send_node_message(node: Node2D, message: Dictionary)

## Tracks the current active control
var current_active_control: Node2D = null
## Keeps track of objects within the context of the canvas
var canvas_object_tracker: Dictionary = {}
## Keeps track of the last object index
var last_object_index: int = -1
## Keeps track of the last mouse position on canvas
var last_canvas_mouse_position: Vector2 = Vector2.ZERO
## Keeps track of the the fact that we need to add to canvas at last mouse position
var add_to_canvas_mouse_position: bool = false
## Keeps track that when we close the popup an action requesting canvas position is needed or not
var mouse_position_request_performed: bool = false


# Initialize before the _ready() function
func _on_tree_entered():
	# Set the design canvas mode mode
	%DesignCanvas.canvas_mode = canvas_mode


# Initialize
func _ready():
	# Generic stuff
	if ProjectManager.scenes_metadata.has(scene_name):
		populate_scene_nodes()
	
	if canvas_mode == SharedEnums.NodeCanvasMode.ModeRun:
		right_panel.visible = false
		canvas_menu.visible = false
	else:
		right_panel.visible = true
		canvas_menu.visible = true


## Populates nodes from the current open project
func populate_scene_nodes():
	var scene_metadata: Dictionary = ProjectManager.scenes_metadata[scene_name]
	# Re assign the node count
	last_object_index = scene_metadata[SceneMetaData.prop_last_object_id]
	design_canvas.node_count = last_object_index
		
	var scene_objects = scene_metadata[SceneMetaData.prop_nodes]
		
	# Add to scene
	for scene_object in scene_objects:
		var current_object = scene_objects[scene_object]
		var node_id: String = current_object[ObjectProperties.prop_node_id]
		var object_index: int = current_object[ObjectProperties.prop_object_index] 
		var project_object_index: int = current_object[ObjectProperties.prop_project_object_index]
		
		# Create a pre-prepared game object
		add_game_object_url_to_canvas(node_id, project_object_index, object_index, current_object)


## Adds a node with a specific resource URL to canvas
func add_game_object_url_to_canvas(url: String, project_object_index: int, created_object_index: int = -1, created_node_metadata = null, manual_position = null):
	var new_node: PackedScene = load(url)
	var node_instance: Node2D = new_node.instantiate()
	var node_kind: SharedEnums.ObjectLayer = node_instance.get_node(Constants.object_metadata_node).get("node_kind")
	var node_mode: SharedEnums.NodeCanvasMode = canvas_mode
	
	# Get the instance's metadata node
	var node_instance_metadata: ObjectMetaData = node_instance.get_node(Constants.object_metadata_node)
	node_instance_metadata.project_object_index = project_object_index
	
	if created_node_metadata != null:
		# Assign already exisiting metadata
		node_instance_metadata.object_index = created_object_index
		node_instance_metadata.assign_metadata(created_node_metadata)
	else:
		if manual_position == null and not mouse_position_request_performed:
			# Default metadata and object initialization
			node_instance_metadata.position_x = design_canvas.camera.position.x
			node_instance_metadata.position_y = design_canvas.camera.position.y
		else:
			# Manual position request has been made
			node_instance_metadata.position_x = manual_position.x
			node_instance_metadata.position_y = manual_position.y
	
	# Add a new object and track its index together with in the metadata
	var object_index = design_canvas.add_new_node(node_instance, node_kind, node_mode, created_object_index)
	var object_id: String = "obj_" + str(object_index)
	
	node_instance_metadata.object_index = object_index
	node_instance_metadata.object_id = object_id
	
	# Scene metadata instance
	var node_position = Vector2(node_instance_metadata.position_x, node_instance_metadata.position_y)
	canvas_object_tracker[str(object_index)] = ProjectManager.create_new_scene_object(scene_name, url, object_id, \
		node_position, node_instance_metadata.prop_values)
	
	# Track last object index
	if created_object_index < 0:
		last_object_index = object_index
	
	# Set tab is invalidated
	if created_object_index < 0:
		tab_common.is_invalidated = true
	
	last_canvas_mouse_position = Vector2.ZERO
	mouse_position_request_performed = false


## Push settings for the canvas
func apply_canvas_settings(settings):
	var x_snapping: int = int(settings.x_snapping)
	var y_snapping: int = int(settings.y_snapping)
	
	design_canvas.grid_snapping = Vector2(x_snapping, y_snapping)


## Synchronizes the project's metadata with the metadata of all the current objects on canvas
func synchronize_project_scene_metadata():
	var foreground_nodes = design_canvas.get_all_nodes(ActiveHoverNode.NodeKind.foreground)
	var background_nodes = design_canvas.get_all_nodes(ActiveHoverNode.NodeKind.background)
	var tiles = design_canvas.get_all_nodes(ActiveHoverNode.NodeKind.tile)
	var current_project_manager_scene = ProjectManager.scenes_metadata[scene_name]
	
	# Store the last object index
	current_project_manager_scene[SceneMetaData.prop_last_object_id] = last_object_index
	
	var all_nodes = [foreground_nodes, background_nodes, tiles]
	
	for node_group in all_nodes:
		for child_node in node_group:
			var object_metadata: ObjectMetaData = child_node.object_metadata
			var object_index: int = object_metadata.object_index
			var project_object_index: Dictionary = canvas_object_tracker[str(object_index)]
			var object_project_object_index: int = object_metadata.project_object_index
			
			project_object_index[ObjectProperties.prop_position_x] = object_metadata[ObjectMetaData.prop_position_x]
			project_object_index[ObjectProperties.prop_position_y] = object_metadata[ObjectMetaData.prop_position_y]
			project_object_index[ObjectProperties.prop_object_index] = object_index
			project_object_index[ObjectProperties.prop_project_object_index] = object_project_object_index
			project_object_index[ObjectProperties.prop_rotation] = object_metadata[ObjectMetaData.prop_rotation]
			project_object_index[ObjectProperties.prop_custom_properties] = object_metadata.prop_values
			project_object_index[ObjectProperties.prop_object_id] = object_metadata.object_id


# Save the tab's content
func save_tab():
	# Synchronize metadata
	synchronize_project_scene_metadata()
	# Save scene
	ProjectManager.save_scene(scene_name, ProjectManager.scenes_metadata[scene_name])
	# Set tab is invalidated
	tab_common.is_invalidated = false


# When a node is selected on canvas
func _on_design_canvas_node_selected(node, node_index, node_kind):
	# Invalidate properties
	properties_editor.fill_properties_for_object(node)
	current_active_control = node


# When a node is repositioned on canvas
func _on_design_canvas_node_moved(node, node_index, node_kind):
	# Properties UI update
	properties_editor.update_property(ObjectMetaData.prop_position_x, node.position.x)
	properties_editor.update_property(ObjectMetaData.prop_position_y, node.position.y)
	# Object Metadata update
	current_active_control.object_metadata.position_x = node.position.x
	current_active_control.object_metadata.position_y = node.position.y
	# Set tab is invalidated
	tab_common.is_invalidated = true


# When a node is rotated on canvas
func _on_design_canvas_node_rotated(node, node_index, node_kind):
	properties_editor.update_property(ObjectMetaData.prop_rotation, node.rotation_degrees)
	# Object Metadata update
	current_active_control.object_metadata.rotation = node.rotation_degrees
	# Set tab is invalidated
	tab_common.is_invalidated = true


# Properties editor event handling
func _on_properties_editor_property_changed(property_set_id, property_id, new_value, is_property_custom):
	if current_active_control != null:
		var object_index: int = current_active_control.object_metadata.object_index
		
		if is_property_custom:
			current_active_control.object_metadata.set_property(property_id, new_value, is_property_custom)
			current_active_control.object_functionality.set_property(property_id, new_value, is_property_custom)
		else:
			match property_id:
				ObjectMetaData.prop_position_x:
					current_active_control.position.x = int(new_value)
					current_active_control.object_metadata.position_x = int(new_value)
				ObjectMetaData.prop_position_y:
					current_active_control.position.y = int(new_value)
					current_active_control.object_metadata.position_y = int(new_value)
				ObjectMetaData.prop_rotation:
					current_active_control.rotation_degrees = int(new_value)
					current_active_control.object_metadata.rotation = int(new_value)
		
		# Set tab is invalidated
		tab_common.is_invalidated = true


# Message sent from a node to the canvas container
func _on_design_canvas_send_node_message(node, message):
	emit_signal("design_canvas_send_node_message", node, message)


# When a node is deleted
func _on_design_canvas_node_deleted(node, object_id, node_index, node_kind):
	canvas_object_tracker.erase(str(node_index))
	ProjectManager.delete_scene_object(scene_name, object_id)
	tab_common.is_invalidated = true


# Add node button has been pressed
func _on_add_node_button_pressed():
	emit_signal("add_node_pressed", self, null)


# Save scene button has been pressed
func _on_save_scene_button_pressed():
	emit_signal("save_scene_pressed", self)
	save_tab()


# Canvas settings button has been pressed
func _on_canvas_settings_button_pressed():
	emit_signal("canvas_settings_pressed", self)


# All nodes deselected on the canvas
func _on_design_canvas_all_nodes_deselected():
	current_active_control = null
	properties_editor.clear_all_properties()


# Close button has been pressed
func _on_close_tab_button_pressed():
	save_tab()
	emit_signal("tab_close_request", self, scene_name)


# Track any kind of click needing action
func _on_design_canvas_mouse_released(mouse_button, mouse_position):
	if mouse_button == MOUSE_BUTTON_RIGHT:
		add_to_canvas_mouse_position = true
		last_canvas_mouse_position = mouse_position
		mouse_position_request_performed = false
		
		var current_global_positon: Vector2 = get_global_mouse_position()
		popup_menu.popup(Rect2i(current_global_positon.x, current_global_positon.y, \
			popup_menu.size.x, popup_menu.size.y))


# An action is pressed on the popup menu
func _on_popup_menu_index_pressed(index):
	match index:
		0:
			mouse_position_request_performed = true
			emit_signal("add_node_pressed", self, last_canvas_mouse_position)

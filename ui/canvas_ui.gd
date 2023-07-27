extends Control

## Holder for the scene name
@export var scene_name: String = ""

## Canvas UI mode
@export var canvas_mode: SharedEnums.NodeCanvasMode = SharedEnums.NodeCanvasMode.ModeDesign

# Node references
@onready var properties_editor: Control = %PropertiesEditor
@onready var design_canvas: Node2D = %DesignCanvas
@onready var tab_common: Node = $TabCommon

## When the add node button is pressed
signal add_node_pressed(node_instance: Control)
## When the save scene button is pressed
signal save_scene_pressed(node_instance: Control)
## When the canvas settings button is pressed
signal canvas_settings_pressed(node_instance: Control)

## Tracks the current active control
var current_active_control: Node2D = null

## Keeps track of objects within the context of the canvas
var canvas_object_tracker: Dictionary = {}


## Adds a node with a specific resource URL to canvas
func add_game_object_url_to_canvas(url: String):
	var new_node: PackedScene = load(url)
	var node_instance: Node2D = new_node.instantiate()
	var node_kind: SharedEnums.ObjectLayer = node_instance.get_node(Constants.object_metadata_node).get("node_kind")
	var node_mode: SharedEnums.NodeCanvasMode = canvas_mode
	
	# Get the instance's metadata node
	var node_instance_metadata: ObjectMetaData = node_instance.get_node(Constants.object_metadata_node)
	
	# Add a new object and track its index together with in the metadata
	var object_index = design_canvas.add_new_node(node_instance, node_kind, node_mode)
	node_instance_metadata.object_index = object_index
	
	# Scene metadata instance
	canvas_object_tracker[str(object_index)] = ProjectManager.create_new_scene_object(scene_name, url, "", \
		Vector2.ZERO, node_instance_metadata.prop_values)
	
	# Set tab is invalidated
	tab_common.is_invalidated = true


## Synchronizes the project's metadata with the metadata of all the current objects on canvas
func synchronize_project_metadata():
	var foreground_nodes = design_canvas.et_all_nodes(ActiveHoverNode.NodeKind.foreground)
	var background_nodes = design_canvas.et_all_nodes(ActiveHoverNode.NodeKind.background)
	var tiles = design_canvas.et_all_nodes(ActiveHoverNode.NodeKind.background)
	
	var all_nodes = [foreground_nodes, background_nodes, tiles]
	
	for node_group in all_nodes:
		for child_node in node_group:
			var object_metadata: ObjectMetaData = child_node.object_metadata
			var object_index: int = object_metadata.object_index
			var project_object_index: ObjectProperties = canvas_object_tracker[str(object_index)]
			
			var position_prop: Vector2 = Vector2(object_metadata[ObjectMetaData.prop_position_x], object_metadata[ObjectMetaData.prop_position_y])
			project_object_index[ObjectProperties.prop_position] = position_prop
			project_object_index[ObjectProperties.prop_rotation] = object_metadata[ObjectMetaData.prop_rotation]
			project_object_index[ObjectProperties.prop_custom_properties] = object_metadata.prop_values
			project_object_index[ObjectProperties.prop_object_id] = object_metadata.object_id


# Save the tab's content
func save_tab():
	synchronize_project_metadata()
	# Set tab is invalidated
	tab_common.is_invalidated = false


# When a node is selected on canvas
func _on_design_canvas_node_selected(node, node_index, node_kind):
	# Invalidate properties
	properties_editor.fill_properties_for_object(node)
	current_active_control = node


# When a node is repositioned on canvas
func _on_design_canvas_node_moved(node, node_index, node_kind):
	if node == current_active_control:
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
	if node == current_active_control:
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
			current_active_control.object_metadata.set_property(property_id, new_value)
		else:
			match property_id:
				ObjectMetaData.prop_position_x:
					current_active_control.position.x = int(new_value)
				ObjectMetaData.prop_position_y:
					current_active_control.position.y = int(new_value)
				ObjectMetaData.prop_rotation:
					current_active_control.rotation_degrees = int(new_value)
		
		# Set tab is invalidated
		tab_common.is_invalidated = true


# Add node button has been pressed
func _on_add_node_button_pressed():
	emit_signal("add_node_pressed", self)


# Save scene button has been pressed
func _on_save_scene_button_pressed():
	emit_signal("save_scene_pressed", self)


# Canvas settings button has been pressed
func _on_canvas_settings_button_pressed():
	emit_signal("canvas_settings_pressed", self)


func _on_design_canvas_all_nodes_deselected():
	current_active_control = null
	properties_editor.clear_all_properties()


# When a node is deselected on canvas
func _on_design_canvas_node_deselected(node, node_index, node_kind):
	pass # Replace with function body.


# When we hover over a node
func _on_design_canvas_node_hover(node, node_index, node_kind):
	pass # Replace with function body.


# When we end hover on a node
func _on_design_canvas_node_hover_out(node, node_index, node_kind):
	pass # Replace with function body.


# When a node is added to canvas
func _on_design_canvas_node_added(node, node_index, node_kind):
	pass # Replace with function body.


# When mouse is released on canvas
func _on_design_canvas_mouse_released(mouse_button, mouse_position):
	pass # Replace with function body.


# When mouse is clicked on canvas
func _on_design_canvas_mouse_clicked(mouse_button, mouse_position):
	pass # Replace with function body.

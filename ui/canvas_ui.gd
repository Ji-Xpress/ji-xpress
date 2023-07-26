extends Control

## Holder for the scene name
@export var scene_name: String = ""

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


func add_game_object_url_to_canvas(url: String):
	var new_node: PackedScene = load(url)
	var node_instance: Node2D = new_node.instantiate()
	var node_kind: SharedEnums.ObjectLayer = node_instance.get_node(Constants.object_metadata_node).get("node_kind")
	var node_mode: SharedEnums.NodeCanvasMode = node_instance.get_node(Constants.object_metadata_node).get("node_mode")
	
	var object_index = design_canvas.add_new_node(node_instance, node_kind, node_mode)


# Design canvas event handling
func _on_design_canvas_node_hover(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_hover_out(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_selected(node, node_index, node_kind):
	properties_editor.fill_properties_for_object(node)
	current_active_control = node


func _on_design_canvas_node_deselected(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_moved(node, node_index, node_kind):
	if node == current_active_control:
		properties_editor.update_property(ObjectMetaData.prop_position_x, node.position.x)
		properties_editor.update_property(ObjectMetaData.prop_position_x, node.position.y)


func _on_design_canvas_node_rotated(node, node_index, node_kind):
	if node == current_active_control:
		properties_editor.update_property(ObjectMetaData.prop_rotation, node.rotation_degrees)


# Properties editor event handling
func _on_properties_editor_property_changed(property_set_id, property_id, new_value, is_property_custom):
	pass # Replace with function body.


# Add node button has been pressed
func _on_add_node_button_pressed():
	emit_signal("add_node_pressed", self)


# Save scene button has been pressed
func _on_save_scene_button_pressed():
	emit_signal("save_scene_pressed", self)


# Canvas settings button has been pressed
func _on_canvas_settings_button_pressed():
	emit_signal("canvas_settings_pressed", self)


func _on_design_canvas_node_added(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_mouse_released(mouse_button, mouse_position):
	pass # Replace with function body.


func _on_design_canvas_mouse_clicked(mouse_button, mouse_position):
	pass # Replace with function body.


func _on_design_canvas_all_nodes_deselected():
	current_active_control = null
	properties_editor.clear_all_properties()

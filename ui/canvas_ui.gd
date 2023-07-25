extends Control

## Holder for the scene name
@export var scene_name: String = ""

# Node references
@onready var properties_editor: Control = $PanelContainer/HSplitContainer/RightPanel/ControlContainer/PropertiesEditor
@onready var design_canvas: Node2D = $PanelContainer/HSplitContainer/LeftPanel/ControlContainer/SubViewportContainer/SubViewport/DesignCanvas
@onready var tab_common: Node = $TabCommon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Design canvas event handling

func _on_design_canvas_node_hover(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_hover_out(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_selected(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_deselected(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_moved(node, node_index, node_kind):
	pass # Replace with function body.


func _on_design_canvas_node_rotated(node, node_index, node_kind):
	pass # Replace with function body.


# Properties editor event handling
func _on_properties_editor_property_changed(property_set_id, property_id, new_value):
	pass # Replace with function body.

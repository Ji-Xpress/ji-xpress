extends Control

# Track indexes for 
const popup_break_loop: int = 0
const popup_broadcast_message: int = 1
const popup_condition: int = 2
const popup_entry: int = 3
const popup_function: int = 4
const popup_loop: int = 5
const popup_move_object: int = 6
const popup_rotate_object: int = 7
const popup_set_global_variable: int = 8
const popup_set_object_property: int = 9
const popup_set_object_variable: int = 10

# Script name property
@export var script_name: String = ""
@export var object_index: int = -1

# Node references
@onready var tab_common: Node = $TabCommon
@onready var graph_edit: GraphEdit = %GraphEdit
@onready var is_new_file: bool = false
@onready var popup_menu: PopupMenu = $PopupMenu

## When the tab is being closed
signal tab_close_request(node_instance: Control, scene_id: String)

## Contains the position where we need to add a node
var selected_add_position: Vector2 = Vector2.ZERO


# Initialize before the _ready() function
func _on_tree_entered():
	# Initialize the GraphEdit node
	%GraphEdit.script_name = script_name
	%GraphEdit.object_index = object_index
	%GraphEdit.is_new_file = is_new_file


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Save the tab's content
func save_tab():
	# Synchronize metadata
	graph_edit.save_script()


# The tab needs to invalidate content
func _on_graph_edit_node_invalidated():
	tab_common.is_invalidated = true


# Tab needs to mark as has been saved
func _on_graph_edit_node_saved():
	tab_common.is_invalidated = false
	is_new_file = false


# Close tab button has been pressed
func _on_close_tab_button_pressed():
	save_tab()
	emit_signal("tab_close_request", self, script_name)


# There was a problem in the save operation
func _on_graph_edit_node_save_error():
	tab_common.is_invalidated = false


# An item on the popup was clicked
func _on_popup_menu_index_pressed(index):
	var block_url: String = ""
	
	match index:
		popup_break_loop:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_break_loop)
		popup_broadcast_message:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_broadcast_message)
		popup_condition:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_condition)
		popup_entry:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_entry)
		popup_function:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_function)
		popup_loop:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_loop)
		popup_move_object:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_move_object)
		popup_rotate_object:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_rotate_object)
		popup_set_global_variable:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_set_global_variable)
		popup_set_object_property:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_set_object_property)
		popup_set_object_variable:
			block_url = graph_edit.get_block_url_by_type(BlockBase.block_type_set_object_variable)
	
	graph_edit.create_new_block_from_url(block_url, selected_add_position)


# When mouse button is clicked over the graph edit
func _on_graph_edit_mouse_clicked(button_index, canvas_position):
	if button_index == MOUSE_BUTTON_RIGHT:
		var mouse_position = get_global_mouse_position()
		selected_add_position = canvas_position
		graph_edit.release_focus()
		popup_menu.popup(Rect2i(mouse_position.x, mouse_position.y, \
			popup_menu.size.x, popup_menu.size.y))


# Save button has been pressed
func _on_save_scene_button_pressed():
	save_tab()

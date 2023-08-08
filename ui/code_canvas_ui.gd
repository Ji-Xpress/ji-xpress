extends Control

# Node references
@onready var tab_common: Node = $TabCommon
@onready var graph_edit: GraphEdit = %GraphEdit
@onready var script_name: String = ""
@onready var is_new_file: bool = false


# Initialize before the _ready() function
func _on_tree_entered():
	# Initialize the GraphEdit node
	%GraphEdit.script_name = script_name
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

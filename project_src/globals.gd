extends Node

# Canvas node has been clicked
signal canvas_node_clicked(node: Node, node_index: int)
# Canvas node has been unclicked
signal canvas_node_unclicked(node: Node, node_index: int)


## Get the app version setting
func get_app_version():
	return str(ProjectSettings.get_setting("application/config/app_version"))


## Emit signal for canvas node selected
func emit_canvas_node_clicked(node: Node, node_index: int):
	emit_signal("canvas_node_clicked", node, node_index)


## Emit signal for canvas node selected
func emit_canvas_node_unclicked(node: Node, node_index: int):
	emit_signal("canvas_node_unclicked", node, node_index)

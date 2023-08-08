extends GraphEdit

## Holder for the scene name
@export var script_name: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Saves the script
func save_script():
	# Store data on all connections
	# Format: Array of { from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	var all_connections: Array[Dictionary] = get_connection_list()


# When a connection request is made
func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


# Disconnection request is made
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


# Node deletion requested
func _on_delete_nodes_request(nodes: Array):
	pass # Replace with function body.


# Node has been selected
func _on_node_selected(node: Node):
	pass # Replace with function body.


# Node has been deselected
func _on_node_deselected(node: Node):
	pass # Replace with function body.


# Node movement initiated
func _on_begin_node_move():
	pass # Replace with function body.


# Node movement ended
func _on_end_node_move():
	pass # Replace with function body.

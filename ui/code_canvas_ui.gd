extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Connection request has been made
func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


## Disconnection request made
func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	pass # Replace with function body.


## Deletes nodes named with the nodes variable
func _on_graph_edit_delete_nodes_request(nodes: Array):
	pass # Replace with function body.

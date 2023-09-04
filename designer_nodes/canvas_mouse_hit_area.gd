extends Area2D

# Node signals
signal node_clicked(node: Node, node_index: int)
signal node_unclicked(node: Node, node_index: int)
signal node_hover(node: Node, node_index: int)
signal node_hover_out(node: Node, node_index: int)

var parent_node: Node = null
var hit_box_size: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Initialization
func _ready():
	parent_node = get_parent()
	collision_shape.shape.size = hit_box_size
	Globals.connect("canvas_node_clicked", Callable(self, "on_canvas_node_clicked"))
	Globals.connect("canvas_node_unclicked", Callable(self, "on_canvas_node_unclicked"))


# Hit area size
func set_hit_size(vector: Vector2, force_on_shape: bool = false) -> void:
	hit_box_size = vector
	
	if force_on_shape:
		collision_shape.shape.size = hit_box_size


# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_clicked", parent_node, parent_node.object_metadata.node_index)
	elif (event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_MASK_LEFT):
		emit_signal("node_unclicked", parent_node, parent_node.object_metadata.node_index)


# Mouse entred the hit box area
func _on_mouse_entered():
	emit_signal("node_hover", parent_node, parent_node.object_metadata.node_index)


# Mouse left the hitbox area
func _on_mouse_exited():
	emit_signal("node_hover_out", parent_node, parent_node.object_metadata.node_index)


## When a canvas node has been clicked
func on_canvas_node_clicked(node: Node, node_index: int):
	if node_index != parent_node.object_metadata.node_index:
		collision_shape.set_deferred("disabled", true)


## When a canvas node has been unclicked
func on_canvas_node_unclicked(node: Node, node_index: int):
	if node_index != parent_node.object_metadata.node_index:
		collision_shape.set_deferred("disabled", false)


func _on_tree_exiting():
	Globals.disconnect("canvas_node_clicked", Callable(self, "on_canvas_node_clicked"))
	Globals.disconnect("canvas_node_unclicked", Callable(self, "on_canvas_node_unclicked"))

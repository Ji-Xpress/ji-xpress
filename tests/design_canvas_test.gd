extends Control

const selectable_spite_node: PackedScene = preload("res://tests/selectable_sprite_node.tscn")
const selectable_wide_node: PackedScene = preload("res://tests/selectable_sprite_node_wide.tscn")
const selectable_bigger_node: PackedScene = preload("res://tests/selectable_sprite_node_bigger.tscn")

# Design Canvas
@onready var design_canvas: Node2D = $VBoxContainer/SubViewportContainer/SubViewport/DesignCanvas

# When a new node is added what positional offset will it have?
var position_offset: Vector2 = Vector2(0, 0)

# Current selected node angle
var current_node_angle: int = 0


# Node is ready
func _ready():
	# Connect signals
	design_canvas.connect("node_selected", Callable(self, "on_node_selected"))
	design_canvas.connect("node_deselected", Callable(self, "on_node_deselected"))
	design_canvas.connect("node_hover", Callable(self, "on_node_hover"))
	design_canvas.connect("node_hover_out", Callable(self, "on_node_hover_out"))
	design_canvas.connect("node_moved", Callable(self, "on_node_hover_moved"))
	design_canvas.connect("node_rotated", Callable(self, "on_node_hover_rotated"))


# A node has been clicked
func on_node_selected(node: Node2D, node_index: int):
	current_node_angle = node.rotation_degrees


# A node has been clicked
func on_node_deselected(node: Node2D, node_index: int):
	pass


# A node has hover focus
func on_node_hover(node: Node2D, node_index: int):
	# debug
	print("hover " + str(node_index))


# A node has lost hover focus
func on_node_hover_out(node: Node2D, node_index: int):
	# debug
	print("hover out " + str(node_index))


# A node has been moved
func on_node_hover_moved(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind):
	# debug
	print(str(node_index) + " moved to " + str(node.position))


# A node has been rotated
func on_node_hover_rotated(node: Node2D, node_index: int, node_kind: ActiveHoverNode.NodeKind):
	# debug
	print(str(node_index) + " rotated to " + str(node.rotation_degrees))


# Test: Add a new test node
func _on_add_sprite_node_pressed():
	var new_node: Node2D = selectable_spite_node.instantiate()
	new_node.position += position_offset
	position_offset += Vector2(20, 20)
	var designeer_node_index: int = design_canvas.add_new_node(new_node)


# Test: Add a new test wide node
func _on_add_wide_node_pressed():
	var new_node: Node2D = selectable_wide_node.instantiate()
	new_node.position += position_offset
	position_offset += Vector2(20, 20)
	var designeer_node_index: int = design_canvas.add_new_node(new_node)


# Add an even bigger node
func _on_add_bigger_node_pressed():
	var new_node: Node2D = selectable_bigger_node.instantiate()
	new_node.position += position_offset
	position_offset += Vector2(20, 20)
	var designeer_node_index: int = design_canvas.add_new_node(new_node)


# Rotate node
func _on_rotate_45_pressed():
	current_node_angle += 45
	design_canvas.set_current_node_rotation(current_node_angle)

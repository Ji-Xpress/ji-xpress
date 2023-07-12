extends Node2D

const canvas_mouse_hit_area = preload("res://nodes/canvas_mouse_hit_area.tscn")

@onready var node_instances: Node2D = $NodeInstances

# Signal for when a node is selected
signal node_selected(node: Node2D)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# A node has been clicked
func on_node_clicked(node):
	emit_signal("node_selected", node)


# Adding a new node to the node tree
func add_new_node(new_node: Node2D):
	if new_node.has_node("RectExtents2D"):
		var rect_extents_node: Node2D = new_node.get_node("RectExtents2D")
		if rect_extents_node is RectExtents2D:
			# Make the rect_extents node invisible
			rect_extents_node.visible = false
			
			var extents_size: Vector2 = rect_extents_node.size
			var extents_position: Vector2 = rect_extents_node.position
			
			var new_hit_area = canvas_mouse_hit_area.instantiate()
			new_hit_area.position = extents_position
			new_hit_area.set_hit_size(extents_size)
			new_node.call_deferred("add_child", new_hit_area)
			
			new_hit_area.connect("node_clicked", Callable(self, "on_node_clicked"))
			
			call_deferred("add_child", new_node)

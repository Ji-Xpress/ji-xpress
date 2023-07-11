extends Area2D

signal node_clicked(node: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Hit area size
func set_hit_size(vector: Vector2) -> void:
	$CollisionShape2D.shape.size = vector


# Handle mouse input
func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("node_clicked", self)

extends RigidBody2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("explosive"):
		var force: float = body.object_metadata.get_property("explosion_force")
		var force_vector:Vector2 = Vector2(force, force)
		var object_position: Vector2 = body.position
		apply_impulse(force_vector, object_position - position)

extends RigidBody2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)


# Collision detection logic
func _on_body_entered(body):
	if body.is_in_group("explosive"):
		var force: float = body.object_metadata.get_property("explosion_force")
		var force_vector:Vector2 = Vector2(force, force)
		var object_position: Vector2 = body.position
		apply_impulse(force_vector, object_position - position)

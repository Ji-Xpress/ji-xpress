extends RigidBody2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D

# Tracks to see if we are on the floor
var is_on_floor: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
		freeze = true
		camera.enabled = false
	else:
		collision_shape.set_deferred("disabled", false)
		freeze = false
		camera.enabled = true
		mass = float(object_metadata.get_property("mass"))
		
		object_coder.code_execution_engine.execute_from_entrypoint_type("ready")


# Physics loop
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		object_coder.code_execution_engine.execute_from_entrypoint_type("update_loop")
		if is_on_floor:
			if not Input.is_action_pressed("ui_accept"):
				var force_raycast: Vector2 = get_left_right_input()
				apply_central_force(Vector2(force_raycast.x * mass * 500, 0))
			else:
				apply_central_force(Vector2(0, mass * 10000 * -1))


# Checks to see if keyboard is
func get_left_right_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


# Collision detection logic
func _on_body_entered(body):
	if body.is_in_group("explosive"):
		var force: float = float(body.object_metadata.get_property("explosion_force"))
		var force_vector:Vector2 = Vector2(0, force * -1)
		var object_position: Vector2 = body.position
		apply_impulse(force_vector, object_position - position)


func _on_floor_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if body.is_in_group("tile"):
			is_on_floor = true


func _on_floor_detector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		if body.is_in_group("tile"):
			is_on_floor = false


# Property change event handling
func _on_object_functionality_property_changed(property, value, is_custom):
	pass # Replace with function body.

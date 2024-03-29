extends RigidBody2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var floor_detector_collision_shape: CollisionShape2D = $FloorDetector/CollisionShape2D
@onready var camera: Camera2D = $Camera2D
@onready var floor_detector: Area2D = $FloorDetector

var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
		floor_detector_collision_shape.set_deferred("disabled", true)
		freeze = true
		camera.enabled = false
	else:
		update_code_execution_engine = object_coder.code_execution_engine()
		
		collision_shape.set_deferred("disabled", false)
		floor_detector_collision_shape.set_deferred("disabled", false)
		freeze = false
		camera.enabled = true
		mass = float(object_metadata.get_property("mass"))
		
		var code_execution_engine = object_coder.code_execution_engine(true)
		code_execution_engine.execute_from_entrypoint_type("ready")


# Physics loop
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")
		
		if is_on_floor():
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


# Checks to see if the fellow is on the floor
func is_on_floor():
	var overlapping_bodies = floor_detector.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("tile"):
			return true
	
	return false


# Property change event handling
func _on_object_functionality_property_changed(property, value, is_custom, run_mode):
	if property == "mass":
		if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
			if str(value).is_valid_float():
				mass = float(value)


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine(true)
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# When the alien hits a physics body
func _on_floor_detector_body_entered(body):
	if body != self:
		SharedGameObjectLogic.common_collision_handler(body, object_coder, {
			"is_on_floor": is_on_floor()
		})


# An area entered the floor detector
func _on_floor_detector_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder, {
		"is_on_floor": is_on_floor()
	})


# Block functions

## Apply central impulse block function
func central_impulse(parameters: Dictionary):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		apply_central_impulse(Vector2(parameters.force_x, parameters.force_y))
	return true


## Apply central force block function
func central_force(parameters: Dictionary):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		apply_central_force(Vector2(parameters.force_x, parameters.force_y))
	return true

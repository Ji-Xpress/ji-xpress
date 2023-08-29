extends RigidBody2D

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sensor_collision_shape: CollisionShape2D = $CollisionSensor/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var update_code_execution_engine: CodeExecutionEngine = null
var is_active: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.set_deferred("disabled", false)
		
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
		mass = float(object_metadata.get_property("mass"))
		
		set_deferred("freeze", false)
	else:
		collision_shape.set_deferred("disabled", true)
		sensor_collision_shape.set_deferred("disabled", true)
		set_deferred("freeze", true)
	
	is_active = str(object_metadata.get_property("is_active")) == "true"
	activate()


## Activates or deactivates the box
func activate():
	SharedGameObjectLogic.common_activate(is_active, sprite, object_metadata, collision_shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


func _on_object_functionality_property_changed(property, value, is_custom):
	if property == "is_active":
		is_active = str(value) == "true"
		activate()


func _on_collision_sensor_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


func _on_collision_sensor_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary):
	queue_free()


## Apply central impulse block function
func central_impulse(parameters: Dictionary):
	apply_central_impulse(Vector2(parameters.force_x, parameters.force_y))
	return true


## Apply central force block function
func central_force(parameters: Dictionary):
	apply_central_force(Vector2(parameters.force_x, parameters.force_y))
	return true

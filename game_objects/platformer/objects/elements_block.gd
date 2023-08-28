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
	is_active = str(object_metadata.get_property("is_active")) == "true"
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = false
		
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	else:
		collision_shape.disabled = true
		sensor_collision_shape.disabled = true
	
	mass = object_metadata.get_property("mass")


## Activates or deactivates the box
func activate():
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = not is_active
		sensor_collision_shape.disabled = not is_active


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


func _on_object_functionality_property_changed(property, value, is_custom):
	if property == "is_active":
		is_active = str(value) == "true"
		activate()


func _on_collision_sensor_area_entered(area):
	var body_groups = area.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


func _on_collision_sensor_body_entered(body):
	var body_groups = body.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")
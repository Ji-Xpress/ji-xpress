extends Area2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var object_coder: ObjectCoder = $ObjectCoder

var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		# Initialize update code executor engine
		update_code_execution_engine = object_coder.code_execution_engine()
		
		collision_shape.set_deferred("disabled", false)
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")


# Body entered
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Block functions

## Destroys the object
func destroy(parameters: Dictionary = {}):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		queue_free()


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# During the update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

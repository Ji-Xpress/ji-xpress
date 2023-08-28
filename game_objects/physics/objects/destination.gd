extends Area2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var transition_timer: Timer = $TransitionTimer
@onready var object_coder: ObjectCoder = $ObjectCoder

var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		update_code_execution_engine = object_coder.code_execution_engine()
		
		collision_shape.set_deferred("disabled", false)
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")


# Signal that we need to change the scene
func signal_scene_change():
	var message_payload = NodeToCanvasMessages.construct_scene_change_message(object_metadata.get_property("destination_scene"))
	object_functionality.send_message_to_canvas(message_payload)


# Check to see if the alien has encountered the body
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)

# During the physics loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

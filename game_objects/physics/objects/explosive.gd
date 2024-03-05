extends StaticBody2D

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
		update_code_execution_engine = object_coder.code_execution_engine()
		collision_shape.set_deferred("disabled", false)
		var code_execution_engine = object_coder.code_execution_engine(true)
		code_execution_engine.execute_from_entrypoint_type("ready")


# During the physics loop
func _physics_process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")

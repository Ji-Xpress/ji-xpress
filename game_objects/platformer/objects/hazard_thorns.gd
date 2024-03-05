extends Area2D

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active: bool = true
# Update loop code execution
var update_code_execution_engine: CodeExecutionEngine = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine = object_coder.code_execution_engine()
		var code_execution_engine = object_coder.code_execution_engine(true)
		code_execution_engine.execute_from_entrypoint_type("ready")
	else:
		collision_shape.set_deferred("disabled", true)
	
	activate()


## Activates the gear
func activate():
	SharedGameObjectLogic.common_activate(is_active, sprite, object_metadata, collision_shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


# When an area enters
func _on_area_entered(area):
	SharedGameObjectLogic.common_collision_handler(area, object_coder)


# When a body enters
func _on_body_entered(body):
	SharedGameObjectLogic.common_collision_handler(body, object_coder)


# Value has changed
func _on_object_functionality_property_changed(property, value, is_custom, run_mode):
	match property:
		"is_active":
			is_active = str(value) == "true"
			activate()


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine(true)
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary = {}):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		queue_free()

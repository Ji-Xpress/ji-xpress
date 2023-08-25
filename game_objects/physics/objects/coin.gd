extends Area2D

# Node references
@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var object_coder: ObjectCoder = $ObjectCoder


# Called when the node enters the scene tree for the first time.
func _ready():
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeDesign:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)
		object_coder.code_execution_engine.execute_from_entrypoint_type("ready")


# When a body enters
func _on_body_entered(body):
	if not SharedState.expression_variables.has("entry_collides"):
		SharedState.expression_variables["entry_collides"] = {}
	
	var body_groups = body.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group
		}
		
		object_coder.code_execution_engine.execute_from_entrypoint_type("collides")


# Block functions

## Destroys the object
func destroy(parameters: Dictionary):
	queue_free()


# During the update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		object_coder.code_execution_engine.execute_from_entrypoint_type("update_loop")

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
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("ready")
	else:
		collision_shape.disabled = true
	
	is_active = str(object_metadata.get_property("is_active")) == "true"
	activate()


## Activates the door
func activate():
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = not is_active


# When an area enters
func _on_area_entered(area):
	var body_groups = area.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


# When a body enters
func _on_body_entered(body):
	var body_groups = body.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group
		}
		
		var code_execution_engine = object_coder.code_execution_engine()
		code_execution_engine.execute_from_entrypoint_type("collides")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


# Value has changed
func _on_object_functionality_property_changed(property, value, is_custom):
	match property:
		"is_active":
			is_active = str(value) == "true"
			activate()


# Process the broadcast message
func _on_object_coder_broadcast(message_id, message):
	var code_execution_engine = object_coder.code_execution_engine()
	code_execution_engine.execute_from_entrypoint_type("broadcast")


# Destroy the object
func destroy(params: Dictionary):
	queue_free()

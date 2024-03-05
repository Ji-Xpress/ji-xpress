extends Node
class_name SharedGameObjectLogic


static func common_collision_handler(body: Node, object_coder: ObjectCoder, extras = {}):
	if not SharedState.expression_variables.has("entry_collides"):
		SharedState.expression_variables["entry_collides"] = {}
	
	var body_groups = body.get_groups()
	
	if body_groups.size() > 0:
		var body_group = body_groups[0]
		
		SharedState.expression_variables["entry_collides"]["body"] = {
			"type": body_group,
			"object_id": body.object_metadata.object_id
		}
		
		for extra in extras:
			SharedState.expression_variables["entry_collides"]["body"][extra] = extras[extra]
		
		var code_execution_engine = object_coder.code_execution_engine(true)
		code_execution_engine.execute_from_entrypoint_type("collides")


static func common_activate(is_active: bool, sprite: Node, object_metadata: ObjectMetaData, collision_shape: CollisionShape2D):
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.set_deferred("disabled", not is_active)

extends Area2D

const rotation_speed: int = 1

@onready var object_metadata: ObjectMetaData = $ObjectMetaData
@onready var object_functionality: ObjectFunctionality = $ObjectFunctionality
@onready var object_coder: ObjectCoder = $ObjectCoder
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active: bool = true
var tween: Tween = null
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
	
	tween = create_tween()
	is_active = str(object_metadata.get_property("is_active")) == "true"
	initialize_rotation()
	activate()


## Activates the gear
func activate():
	if is_active:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 0.5)
	
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		collision_shape.disabled = not is_active


# Update loop
func _process(delta):
	if object_metadata.node_mode == SharedEnums.NodeCanvasMode.ModeRun:
		update_code_execution_engine.execute_from_entrypoint_type("update_loop")


## Tween callback
func rotate_tween_callback():
	tween.stop()
	sprite.rotation_degrees = 0
	
	tween = create_tween()
	var rotation_duration: float = float(60) / float(rotation_speed * 60)
	tween.tween_property(sprite, "rotation_degrees", 360, rotation_duration)
	tween.tween_callback(rotate_tween_callback)
	tween.play()


## Sets gear rotation speed
func initialize_rotation():
	if tween.is_running():
		tween.stop()
	
	sprite.rotation_degrees = 0
	var rotation_duration: float = float(60) / float(rotation_speed * 60)
	tween = create_tween()
	tween.tween_property(sprite, "rotation_degrees", 360, rotation_duration)
	tween.tween_callback(rotate_tween_callback)
	tween.play()


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
